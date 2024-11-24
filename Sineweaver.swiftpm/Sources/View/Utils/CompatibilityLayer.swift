import Foundation
import OSLog
import SpriteKit

private let log = Logger(subsystem: "Sineweaver", category: "CompatibilityLayer")

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public typealias Image = NSImage
public typealias Color = NSColor

extension NSImage {
    public convenience init(fromCG cgImage: CGImage) {
        self.init(cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))
    }
}

private func keyboardKeys(from event: NSEvent) -> [KeyboardKey] {
    switch event.keyCode {
    case 0x33:
        return [.backspace]
    case 0x75:
        return [.delete]
    default:
        return event.charactersIgnoringModifiers?.map { .char($0) } ?? []
    }
}

// Slightly hacky, relies on the fact that the Objective-C runtime
// allows us to override methods from extensions.

extension SKNode {
    public dynamic override func mouseDown(with event: NSEvent) {
        log.debug("Mouse down on \(self)")
        (self as? SceneInputHandler)?.inputDown(at: event.location(in: self))
    }
    
    public dynamic override func mouseDragged(with event: NSEvent) {
        log.debug("Mouse dragged on \(self)")
        (self as? SceneInputHandler)?.inputDragged(to: event.location(in: self))
    }
    
    public dynamic override func mouseUp(with event: NSEvent) {
        log.debug("Mouse up on \(self)")
        (self as? SceneInputHandler)?.inputUp(at: event.location(in: self))
    }
    
    public dynamic override func keyDown(with event: NSEvent) {
        log.debug("Key down on \(self)")
        (self as? SceneInputHandler)?.inputKeyDown(with: keyboardKeys(from: event))
    }
    
    public dynamic override func keyUp(with event: NSEvent) {
        log.debug("Key up on \(self)")
        (self as? SceneInputHandler)?.inputKeyUp(with: keyboardKeys(from: event))
    }
    
    public func runFilePicker(_ completion: @escaping ([URL]) -> Void) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        if let window = scene?.view?.window {
            panel.beginSheetModal(for: window) {
                if $0 == .OK {
                    completion(panel.urls)
                } else {
                    completion([])
                }
            }
        } else {
            let result = panel.runModal()
            if result == .OK {
                completion(panel.urls)
            } else {
                completion([])
            }
        }
    }
}

extension SKView {
    public override func scrollWheel(with event: NSEvent) {
        log.debug("Scrolled")
        (scene as? SceneInputHandler)?.inputScrolled(deltaX: event.deltaX, deltaY: event.deltaY, deltaZ: event.deltaZ)
    }
}

#elseif canImport(UIKit)

import UIKit
import MobileCoreServices

public typealias Image = UIImage
public typealias Color = UIColor

extension UIImage {
    public convenience init(fromCG cgImage: CGImage) {
        self.init(cgImage: cgImage)
    }
}

@MainActor
private var documentPickerDelegates: [UIDocumentPickerViewController: DocumentPickerDelegate] = [:]

private class DocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {
    private let completion: ([URL]) -> Void
    
    init(completion: @escaping ([URL]) -> Void) {
        self.completion = completion
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        completion([])
        controller.dismiss(animated: true, completion: nil)
        documentPickerDelegates[controller] = nil
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        completion(urls)
        controller.dismiss(animated: true)
        documentPickerDelegates[controller] = nil
    }
}

extension SKNode {
    public dynamic override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug("Touch began on \(self)")
        guard let touch = touches.first else { return }
        (self as? SceneInputHandler)?.inputDown(at: touch.location(in: self))
    }
    
    public dynamic override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug("Touch moved on \(self)")
        guard let touch = touches.first else { return }
        (self as? SceneInputHandler)?.inputDragged(to: touch.location(in: self))
    }
    
    public dynamic override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug("Touch ended on \(self)")
        guard let touch = touches.first else { return }
        (self as? SceneInputHandler)?.inputUp(at: touch.location(in: self))
    }
    
    public func runFilePicker(_ completion: @escaping ([URL]) -> Void) {
        let picker = UIDocumentPickerViewController()
        let delegate = DocumentPickerDelegate(completion: completion)
        documentPickerDelegates[picker] = delegate
        picker.delegate = delegate
        if let root = scene?.view?.window?.rootViewController {
            root.present(picker, animated: true, completion: nil)
        } else {
            log.warning("No window found!")
            completion([])
        }
    }
}

#else
#error("Unsupported platform")
#endif
