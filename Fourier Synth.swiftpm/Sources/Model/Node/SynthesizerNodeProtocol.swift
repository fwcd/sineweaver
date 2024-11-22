//
//  SynthesizerNodeProtocol.swift
//  Fourier Synth
//
//  Created on 22.11.24
//

import Foundation

protocol SynthesizerNodeProtocol: Hashable, Codable, Sendable {
    func render(buffer: UnsafeMutableBufferPointer<Float>, context: SynthesizerContext)
}
