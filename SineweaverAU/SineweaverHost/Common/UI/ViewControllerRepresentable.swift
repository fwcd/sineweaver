//
//  ViewControllerRepresentable.swift
//  Sineweaver
//
//  Created on 04.03.25
//

import SwiftUI

#if os(iOS) || os(visionOS)

struct AUViewControllerUI: UIViewControllerRepresentable {
    var auViewController: UIViewController?

    init(viewController: UIViewController?) {
        self.auViewController = viewController
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        guard let auViewController = self.auViewController else {
            return UIViewController()
        }
        
        let viewController = UIViewController()
        viewController.addChild(auViewController)

        let frame: CGRect = viewController.view.bounds
        auViewController.view.frame = frame
        
        viewController.view.addSubview(auViewController.view)
        auViewController.didMove(toParent: viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No op
    }
}
#elseif os(macOS)
struct AUViewControllerUI: NSViewControllerRepresentable {
    
    var auViewController: NSViewController?

    init(viewController: NSViewController?) {
        self.auViewController = viewController
    }
    
    func makeNSViewController(context: Context) -> NSViewController {
        return self.auViewController!
    }
    
    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
        // No opp
    }
}
#endif
