//
//  MIDIEventList+ForEach.swift
//  SineweaverAU
//
//  Created on 05.03.25
//

// Source: https://furnacecreek.org/blog/2024-04-06-modern-coremidi-event-handling-with-swift

import CoreMIDI
import Foundation

typealias MIDIForEachBlock = (MIDIUniversalMessage, MIDITimeStamp) -> Void

private final class MIDIForEachContext {
    var block: MIDIForEachBlock

    init(block: @escaping MIDIForEachBlock) {
        self.block = block
    }
}

extension UnsafePointer where Pointee == MIDIEventList {
    func forEach(_ block: MIDIForEachBlock) {
        withoutActuallyEscaping(block) { escapingClosure in
            let context = MIDIForEachContext(block: escapingClosure)
            withExtendedLifetime(context) {
                let contextPointer = Unmanaged.passUnretained(context).toOpaque()
                MIDIEventListForEachEvent(self, { contextPointer, timestamp, message in
                    guard let contextPointer else {
                        return
                    }
                    
                    let localContext = Unmanaged<MIDIForEachContext>.fromOpaque(contextPointer).takeUnretainedValue()
                    localContext.block(message, timestamp)
                }, contextPointer)
            }
        }
    }
}
