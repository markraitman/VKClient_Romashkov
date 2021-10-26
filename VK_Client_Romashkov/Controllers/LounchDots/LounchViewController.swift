//
//  LounchDotsViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 11.01.2021.
//

import UIKit

final class LounchDotsViewController: UIViewController {

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        animationDot()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLoad()

        dot1.layer.cornerRadius = dot1.frame.width / 2
        dot2.layer.cornerRadius = dot1.frame.width / 2
        dot3.layer.cornerRadius = dot1.frame.width / 2
    }

    // MARK: - Outlets
    @IBOutlet weak var dot1: UIView!
    @IBOutlet weak var dot2: UIView!
    @IBOutlet weak var dot3: UIView!

    // MARK: - Actions
    private func animationIsOn() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.repeat, .autoreverse],
                       animations: {self.dot1.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)},
                       completion: nil)
        UIView.animate(withDuration: 1,
                       delay: 0.5,
                       options: [.repeat, .autoreverse],
                       animations: {self.dot2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)},
                       completion: nil)
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: [.repeat, .autoreverse],
                       animations: {self.dot3.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)},
                       completion: nil)
    }

    private func animationIsOff() {
        UIView.animate(withDuration: 5,
                       delay: 0,
                       options: [],
                       animations: {self.dot3.alpha = 0.999},
                       completion: {(success) in self.performSegue(withIdentifier: "ifYouAreNotEnoughBored", sender: self)})
    }
    
    private func animationDot() {
        animationIsOn()
        animationIsOff()
    }
}
