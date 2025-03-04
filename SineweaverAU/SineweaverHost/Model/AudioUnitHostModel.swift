//
//  AudioUnitHostModel.swift
//  Sineweaver
//
//  Created on 04.03.25
//

import SwiftUI
import CoreMIDI
import AudioToolbox

@MainActor
@Observable
class AudioUnitHostModel {
    /// The playback engine used to play audio.
    private let playEngine = SimplePlayEngine()

    /// The model providing information about the current Audio Unit
    var viewModel = AudioUnitViewModel()

    var isPlaying: Bool { playEngine.isPlaying }

    /// Audio Component Description
    let type: String
    let subType: String
    let manufacturer: String

    let wantsAudio: Bool
    let wantsMIDI: Bool
    let isFreeRunning: Bool

    let auValString: String

    init(type: String = "aumu", subType: String = "sine", manufacturer: String = "fwcd") {
        self.type = type
        self.subType = subType
        self.manufacturer = manufacturer
        let wantsAudio = type.fourCharCode == kAudioUnitType_MusicEffect || type.fourCharCode == kAudioUnitType_Effect
        self.wantsAudio = wantsAudio

        let wantsMIDI = type.fourCharCode == kAudioUnitType_MIDIProcessor ||
        type.fourCharCode == kAudioUnitType_MusicDevice ||
        type.fourCharCode == kAudioUnitType_MusicEffect
        self.wantsMIDI = wantsMIDI

        let isFreeRunning = type.fourCharCode == kAudioUnitType_MIDIProcessor ||
        type.fourCharCode == kAudioUnitType_MusicDevice ||
        type.fourCharCode == kAudioUnitType_Generator
        self.isFreeRunning = isFreeRunning

        auValString = "\(type) \(subType) \(manufacturer)"

        loadAudioUnit()
    }

    private func loadAudioUnit() {
		Task {
			let viewController = await playEngine.initComponent(type: type, subType: subType, manufacturer: manufacturer)

				self.viewModel = AudioUnitViewModel(showAudioControls: self.wantsAudio,
													showMIDIContols: self.wantsMIDI,
													title: self.auValString,
													message: "Successfully loaded (\(self.auValString))",
													viewController: viewController)
				
				if self.isFreeRunning {
					self.playEngine.startPlaying()
			}
		}
    }

    func startPlaying() {
        playEngine.startPlaying()
    }

    func stopPlaying() {
        playEngine.stopPlaying()
    }
}
