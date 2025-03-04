//
//  SineweaverExtensionAudioUnit.swift
//  Sineweaver
//
//  Created on 04.03.25
//

import AVFoundation

public class SineweaverExtensionAudioUnit: AUAudioUnit, @unchecked Sendable {
    @MainActor let synthesizer = {
        let synthesizer = SynthesizerViewModel()
        // The default preset is the last chapter in the tutorial (i.e. an oscillator with unison/detune + an envelope)
        SynthesizerChapter.allCases.last?.configure(synthesizer: &synthesizer.model)
        return synthesizer
    }()
    
	private var outputBus: AUAudioUnitBus?
	private var _outputBusses: AUAudioUnitBusArray!

	private var format:AVAudioFormat

	@objc override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
		self.format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 2)!
        synthesizer.synthesizer.initializeAudioThreadState(sampleRate: format.sampleRate)
        
		try super.init(componentDescription: componentDescription, options: options)
        
		outputBus = try AUAudioUnitBus(format: self.format)
        outputBus?.maximumChannelCount = 2
		_outputBusses = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.output, busses: [outputBus!])
        
        maximumFramesToRender = 1024 // TODO: Do we need this?
	}

	public override var outputBusses: AUAudioUnitBusArray {
		return _outputBusses
	}

    // MARK: - MIDI
    public override var audioUnitMIDIProtocol: MIDIProtocolID {
        return ._2_0
    }

    // MARK: - Rendering
    public override var internalRenderBlock: AUInternalRenderBlock {
        { [self] actionFlags, timestamp, frameCount, outputBusNumber, outputData, realtimeEventListHead, pullInputBlock in
            if frameCount > maximumFramesToRender {
                return kAudioUnitErr_TooManyFramesToProcess
            }
            
            return synthesizer.synthesizer.render(frameCount: frameCount, audioBuffers: outputData)
        }
    }

    // Allocate resources required to render.
    // Subclassers should call the superclass implementation.
    public override func allocateRenderResources() throws {
		let outputChannelCount = self.outputBusses[0].format.channelCount
		
		try super.allocateRenderResources()
	}

    // Deallocate resources allocated in allocateRenderResourcesAndReturnError:
    // Subclassers should call the superclass implementation.
    public override func deallocateRenderResources() {
        super.deallocateRenderResources()
    }

	public func setupParameterTree(_ parameterTree: AUParameterTree) {
		self.parameterTree = parameterTree

		setupParameterCallbacks()
	}

	private func setupParameterCallbacks() {
		// A function to provide string representations of parameter values.
		parameterTree?.implementorStringFromValueCallback = { param, valuePtr in
			guard let value = valuePtr?.pointee else {
				return "-"
			}
			return NSString.localizedStringWithFormat("%.f", value) as String
		}
	}
}
