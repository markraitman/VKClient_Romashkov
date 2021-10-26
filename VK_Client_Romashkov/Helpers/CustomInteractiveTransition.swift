//
//  CustomInteractiveTransition.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 17.02.2021.
//

import UIKit

final class CustomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Properties
    
    var viewController: UIViewController? {
        didSet {
            let recognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeGesture(_:)))
            recognizer.edges = [.left]
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    var hasStarted = false
    var shouldFinished = false
    
    // MARK: - Actions
    
    @objc func edgeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
        
        case .began:
            hasStarted = true
            viewController?.navigationController?.popViewController(animated: true)
        
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.x / (recognizer.view?.bounds.width ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            shouldFinished = progress > 0.33
            update(progress)
            
        case .ended:
            hasStarted = false
            shouldFinished ? finish() : cancel()
            
        case .cancelled:
            hasStarted = false
            cancel()
            
        default:
            return
        }
    }
}
