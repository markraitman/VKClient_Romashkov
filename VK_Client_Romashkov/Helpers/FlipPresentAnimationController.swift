//
//  FlipPresentAnimationController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 20.02.2021.
//

import UIKit

final class FlipPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Frame
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
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
            let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        snapshot.frame = originFrame
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0,
                                   relativeDuration: 1) {
                                    snapshot.frame = finalFrame
                                    snapshot.layer.cornerRadius = 0
                }
        },
            
            completion: { _ in
                toVC.view.isHidden = false
                snapshot.removeFromSuperview()
                fromVC.view.layer.transform = CATransform3DIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
