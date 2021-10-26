//
//  CustomNavigationViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 13.02.2021.
//

import UIKit

final class CustomNavigationViewController: UINavigationController, UINavigationControllerDelegate {
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    // MARK: - Properties
    
    private let interactiveTransition = CustomInteractiveTransition()
    
    // MARK: - Actions
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        if operation == .push {
            interactiveTransition.viewController = toVC
            return CustomPushAnimator()
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                interactiveTransition.viewController = toVC
            }
            return CustomPopAnimator()
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
}

