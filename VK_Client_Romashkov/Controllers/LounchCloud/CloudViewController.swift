//
//  LounchCloudViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 27.01.2021.
//

import UIKit

final class LounchCloudViewController: UIViewController {
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationCloud()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var cloud: UIView!
    
    // MARK: - Animations
    
    func animationCloud() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 10, y: 60))
        path.addQuadCurve(to: CGPoint(x: 20, y: 40), controlPoint: CGPoint(x: 5, y: 50))
        path.addQuadCurve(to: CGPoint(x: 40, y: 20), controlPoint: CGPoint(x: 20, y: 20))
        path.addQuadCurve(to: CGPoint(x: 70, y: 20), controlPoint: CGPoint(x: 55, y: 0))
        path.addQuadCurve(to: CGPoint(x: 80, y: 30), controlPoint: CGPoint(x: 80, y: 20))
        path.addQuadCurve(to: CGPoint(x: 110, y: 60), controlPoint: CGPoint(x: 110, y: 30))
        path.close()
    
        let layerAnimation = CAShapeLayer()
        layerAnimation.path = path.cgPath
        layerAnimation.strokeColor = UIColor.black.cgColor
        layerAnimation.fillColor = UIColor.clear.cgColor
        layerAnimation.lineWidth = 5
        layerAnimation.lineCap = .round
        
        cloud.layer.addSublayer(layerAnimation)
        
        let pathAnimationStart = CABasicAnimation(keyPath: "strokeStart")
        pathAnimationStart.fromValue = 0
        pathAnimationStart.toValue = 1
        pathAnimationStart.duration = 2
        pathAnimationStart.beginTime = 1
        
        let pathAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimationEnd.fromValue = 0
        pathAnimationEnd.toValue = 1
        pathAnimationEnd.duration = 2
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 3
        animationGroup.fillMode = CAMediaTimingFillMode.backwards
        animationGroup.repeatCount = 3
        animationGroup.animations = [pathAnimationStart, pathAnimationEnd]
        layerAnimation.add(animationGroup, forKey: nil)
        
        UIView.animate(withDuration: 8.5,
                       delay: 0,
                       options: [],
                       animations: {self.cloud.alpha = 0.999},
                       completion: {(success) in self.performSegue(withIdentifier: "ifYouAreTiredOfWaiting", sender: self)})
    }
}
