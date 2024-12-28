//
//  WavExportNode.swift
//  Sineweaver
//
//  Created on 28.12.24
//

import Foundation
import OSLog

private let log = Logger(subsystem: "Sineweaver", category: "WavExportNode")

/// A node that writes the samples to a WAV file.
struct WavExportNode: SynthesizerNodeProtocol {
    enum CodingKeys: String, CodingKey {
        case outputURL
    }
    
    var outputURL: URL? = nil
    
    private var samples: [Double] = []
    
    // TODO: Only append to file by seeking to end, potentially see https://stackoverflow.com/questions/25245439/writing-wav-files-of-unknown-length
    
    mutating func render(inputs: [[Double]], output: inout [Double], context: SynthesizerContext) {
        guard let input = inputs.first else { return }
        
        for (i, sample) in input.enumerated() {
            samples.append(sample)
            output[i] = sample
        }
        
        do {
            guard let outputURL else { return }
            try encodeWav(samples: samples, sampleRate: context.sampleRate).write(to: outputURL)
        } catch {
            log.warning("Could not encode WAV: \(error)")
        }
    }
    
    func encodeWav(samples: [Double], sampleRate: Double) -> Data {
        // Source: https://en.wikipedia.org/wiki/WAV#WAV_file_header
        
        var data = Data()
        
        // Master chunk
        data += [0x52, 0x49, 0x46, 0x46] // "RIFF"
        data += bytes(of: UInt32(36 + samples.count * 4).littleEndian) // File size minus 8 bytes
        data += [0x57, 0x41, 0x56, 0x45] // "WAVE"
        
        // Format chunk
        let bitsPerSample = 32 // We write 32-bit Float PCM
        let channels = 1 // mono
        let bytesPerBlock = (channels * bitsPerSample) / 8
        let bytesPerSec = Int(sampleRate) * bytesPerBlock
        data += [0x66, 0x6D, 0x74, 0x20] // "fmt "
        data += bytes(of: UInt32(16).littleEndian) // Chunk size
        data += bytes(of: UInt16(3).littleEndian) // Audio format (IEEE 754 float)
        data += bytes(of: UInt16(channels).littleEndian) // Channels (mono)
        data += bytes(of: UInt32(sampleRate).littleEndian) // Sample rate (in Hz)
        data += bytes(of: UInt32(bytesPerSec).littleEndian) // Number of bytes to be read per second
        data += bytes(of: UInt16(bytesPerBlock).littleEndian) // Number of bytes per block
        data += bytes(of: UInt16(bitsPerSample).littleEndian) // Number of bits per sample
        
        // Data chunk
        data += [0x64, 0x61, 0x74, 0x61] // "data"
        data += bytes(of: UInt32(samples.count * 4).littleEndian) // Size of sample data in bytes
        
        for sample in samples {
            data += bytes(of: Float32(sample))
        }
        
        return data
    }
    
    private func bytes<T>(of value: T) -> Data {
        var value = value
        return withUnsafeBytes(of: &value) { bytes in
            Data(bytes)
        }
    }
}
