//
//  Synthesizer.swift
//  Sineweaver
//
//  Created on 20.11.24
//

@preconcurrency import AVFoundation
import CoreAudio
import CoreMIDI
import Combine
import Foundation
import Synchronization
import OSLog

private let log = Logger(subsystem: "Sineweaver", category: "Synthesizer")

private func configureAVAudioSession() {
    let session = AVAudioSession.sharedInstance()
    do {
        try session.setCategory(.playback)
    } catch {
        log.error("Could not set audio session category: \(error)")
    }
    do {
        log.info("Activating audio session...")
        try session.setActive(true)
    } catch {
        log.error("Could not activate audio session: \(error)")
    }
}

final class Synthesizer: Sendable {
    #if !SINEWEAVER_AU
    private let engine: AVAudioEngine
    #endif
    
    @MainActor var model = SynthesizerModel() {
        didSet {
            Task {
                let model = model
                let frameCount = frameCount.withLock { $0 }
                audioState.withLock { audioState in
                    model.update(buffers: &audioState.buffers, frameCount: frameCount)
                    model.update(states: &audioState.states)
                    audioState.model = model
                }
            }
        }
    }
    
    @MainActor private var activeMidiNotes: Set<Note> = [] {
        didSet {
            model.setPlaying(notes: activeMidiNotes.sorted())
        }
    }
    
    let startTimestamp: SendableAtomic<TimeInterval> = .init(0)
    let level: SendableAtomic<Double> = .init(0)
    
    var startDate: Date {
        Date(timeIntervalSince1970: startTimestamp.wrappedAtomic.load(ordering: .relaxed))
    }
    
    private struct AudioState {
        var model: SynthesizerModel = .init()
        var buffers: SynthesizerModel.Buffers = .init()
        var states: SynthesizerModel.States = .init()
    }
    
    // State shared with the audio thread
    private let audioState = Mutex(AudioState())
    private let frameCount = Mutex(0)

    // Only used on the audio thread
    private nonisolated(unsafe) var context: SynthesizerContext!
    private nonisolated(unsafe) var lastAudioState: AudioState!
    private nonisolated(unsafe) var storedStartTimestamp = false
    
    init() throws {
        #if !SINEWEAVER_AU
        log.info("Booting synthesizer...")
        
        configureAVAudioSession()
        
        engine = AVAudioEngine()

        let mainMixer = engine.mainMixerNode
        let outputNode = engine.outputNode
        
        let outputFormat = outputNode.inputFormat(forBus: 0)
        let sampleRate = outputFormat.sampleRate
        
        let inputFormat = AVAudioFormat(
            commonFormat: outputFormat.commonFormat,
            sampleRate: outputFormat.sampleRate,
            channels: 1,
            interleaved: outputFormat.isInterleaved
        )
        
        initializeAudioThreadState(sampleRate: sampleRate)
        
        let srcNode = AVAudioSourceNode { [unowned self] _, _, frameCount, audioBuffers in
            render(frameCount: frameCount, audioBuffers: audioBuffers)
        }
        
        engine.attach(srcNode)
        engine.connect(srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: outputNode, format: outputFormat)

        log.info("Starting engine")
        try engine.start()
        #endif
    }
    
    /// **ONLY CALL THIS WHEN USING SINEWEAVER FROM THE AU EXTENSION, otherwise this will happen automatically.**
    func initializeAudioThreadState(sampleRate: Double) {
        context = SynthesizerContext(frame: 0, sampleRate: sampleRate)
        lastAudioState = audioState.withLock { $0 }
    }
    
    /// **ONLY CALL THIS WHEN USING SINEWEAVER FROM THE AU EXTENSION, otherwise this will happen automatically.**
    func render(frameCount: AVAudioFrameCount, audioBuffers: UnsafeMutablePointer<AudioBufferList>) -> OSStatus {
        let frameCount = Int(frameCount)
            
        let success = self.audioState.withLockIfAvailable { audioState -> Void in
            render(audioState: &audioState, frameCount: frameCount, audioBuffers: audioBuffers)
            lastAudioState = audioState
        } != nil
        
        if !success {
            render(audioState: &lastAudioState, frameCount: frameCount, audioBuffers: audioBuffers)
        }
        
        return noErr
    }
    
    private func render(audioState: inout AudioState, frameCount: Int, audioBuffers: UnsafeMutablePointer<AudioBufferList>) {
        guard audioState.buffers.output.count == frameCount else {
            self.frameCount.withLock { $0 = frameCount }
            return
        }
        
        if !storedStartTimestamp {
            startTimestamp.wrappedAtomic.store(Date().timeIntervalSince1970, ordering: .relaxed)
            storedStartTimestamp = true
        }
        
        audioState.model.render(using: &audioState.buffers, states: &audioState.states, context: context)
        
        level.wrappedAtomic.store(audioState.buffers.output.map(Swift.abs).reduce(0, max), ordering: .relaxed)
        
        let audioBuffers = UnsafeMutableAudioBufferListPointer(audioBuffers)
        for audioBuffer in audioBuffers {
            let audioBuffer = UnsafeMutableBufferPointer<Float>(audioBuffer)
            for i in 0..<frameCount {
                // Clip the signal to avoid loud pops etc.
                audioBuffer[i] = Float(max(-1, min(1, audioState.buffers.output[i])))
            }
        }
        
        context.frame += frameCount
    }
    
    func handle(event: AURenderEvent) {
        switch event.head.eventType {
        case .midiEventList:
            handle(midiEvents: event.MIDIEventsList)
        default:
            break
        }
    }
    
    private func handle(midiEvents: AUMIDIEventList) {
        withUnsafePointer(to: midiEvents.eventList) { eventListPtr in
            eventListPtr.forEach { midiMessage, midiTimestamp in
                handle(midiMessage: midiMessage, at: midiTimestamp)
            }
        }
    }
    
    private func handle(midiMessage: MIDIUniversalMessage, at midiTimestamp: MIDITimeStamp) {
        switch midiMessage.type {
        case .channelVoice2:
            let v2Message = midiMessage.channelVoice2
            let note = { Note(midiNumber: Int(v2Message.note.number)) }
            switch v2Message.status {
            case .noteOn:
                Task { @MainActor in
                    activeMidiNotes.insert(note())
                }
            case .noteOff:
                Task { @MainActor in
                    activeMidiNotes.remove(note())
                }
            default:
                break
            }
        default:
            break
        }
    }
}
