//
//  FlipDismissAnimationController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 20.02.2021.
//

import UIKit

final class FlipDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Frame
    
    private let destinationFrame: CGRect

    
    init(destinationFrame: CGRect) {
        self.destinationFrame = destinationFrame
    }
    
    // MARK: - Duration
    
    private let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    // MARK: - Transition
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(snapshot)
        fromVC.view.isHidden = true

        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                    snapshot.frame = self.destinationFrame
                }
        },
            
            completion: { _ in
                fromVC.view.isHidden = false
                snapshot.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    
                    toVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
