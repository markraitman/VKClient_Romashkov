//
//  ExtendedFullScreenViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 25.02.2021.
//

import UIKit

final class ExtendedFullScreenViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        extendedFullImage.image = currentPhoto

        extendedFullImage.layer.cornerRadius = 40
        extendedFullImage.isUserInteractionEnabled = true

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture))
        swipeDown.direction = .down
        extendedFullImage.addGestureRecognizer(swipeDown)
    }

    // MARK: - Outlets

    @IBOutlet weak var extendedFullImage: UIImageView!

    // MARK: - Data Source

    var currentPhoto: UIImage!

    // MARK: - Actions

    @objc func swipeDownGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            dismiss(animated: true, completion: nil) }
    }
}

