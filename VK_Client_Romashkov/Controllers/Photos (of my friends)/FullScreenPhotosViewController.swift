//
//  FullScreenPhotosViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 01.02.2021.
//

import UIKit

final class FullScreenPhotosViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = #imageLiteral(resourceName: "Colosus3").cgImage /*view.layer.contents = #imageLiteral(resourceName: "webbg").cgImage*/
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) /*#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)*/
        
        middleScreenImageView.isUserInteractionEnabled = true
        
        let swipePan = UIPanGestureRecognizer(target: self, action: #selector(onPan))
        view.addGestureRecognizer(swipePan)
        
        startAnimations()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var middleScreenImageView: UIImageView!
    @IBOutlet weak var leftScreenImageView: UIImageView!
    @IBOutlet weak var rightScreenImageView: UIImageView!
    
    // MARK: - Data source
    
    var fullScreenPhotos: [Photo] = []
    
    var selectedPhoto = 0
    
    // MARK: - Image
    
    func setImages(){
        var indexPhotoLeft: Int = selectedPhoto - 1
        let indexPhotoMid: Int = selectedPhoto
        var indexPhotoRight: Int = selectedPhoto + 1
        
        if indexPhotoLeft < 0 {
            indexPhotoLeft = fullScreenPhotos.count - 1
        }
        
        if indexPhotoRight > fullScreenPhotos.count - 1 {
            indexPhotoRight = 0
        }
        
        middleScreenImageView.downloadImage(urlPath: (fullScreenPhotos[indexPhotoMid].imageURL))
        leftScreenImageView.downloadImage(urlPath: (fullScreenPhotos[indexPhotoLeft].imageURL))
        rightScreenImageView.downloadImage(urlPath: (fullScreenPhotos[indexPhotoRight].imageURL))
        
        middleScreenImageView.layer.cornerRadius = 40
        leftScreenImageView.layer.cornerRadius = 40
        rightScreenImageView.layer.cornerRadius = 40
        
        let scaleImage = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        self.middleScreenImageView.transform = scaleImage
        self.leftScreenImageView.transform = scaleImage
        self.rightScreenImageView.transform = scaleImage
    }
    
    // MARK: - Animations
    
    var swipeToRight: UIViewPropertyAnimator!
    var swipeToLeft: UIViewPropertyAnimator!
    
    func startAnimations() {
        setImages()
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
                        self.middleScreenImageView.transform = .identity
                        self.leftScreenImageView.transform = .identity
                        self.rightScreenImageView.transform = .identity
                       },
                       completion: nil)
    }
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            swipeToRight = UIViewPropertyAnimator(
                duration: 0.5,
                curve: .linear,
                animations: {
                    UIView.animate(withDuration: 0,
                                   delay: 0,
                                   options: [],
                                   animations: {
                                    let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                    let translation = CGAffineTransform(translationX: self.view.bounds.maxX - 40, y: 0)
                                    let transform = scale.concatenating(translation)
                                    self.middleScreenImageView.transform = transform
                                    self.leftScreenImageView.transform = transform
                                    self.rightScreenImageView.transform = transform
                                   },
                                   completion: {_ in
                                    self.selectedPhoto -= 1
                                    if self.selectedPhoto < 0 {
                                        self.selectedPhoto = self.fullScreenPhotos.count - 1
                                    }
                                    self.startAnimations()
                                   })
                    
                }
            )
            swipeToLeft = UIViewPropertyAnimator(
                duration: 0.5,
                curve: .linear,
                animations: {
                    UIView.animate(withDuration: 0,
                                   delay: 0,
                                   options: [],
                                   animations: {
                                    let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                                    let translation = CGAffineTransform(translationX: -self.view.bounds.maxX + 40, y: 0)
                                    let transform = scale.concatenating(translation)
                                    self.middleScreenImageView.transform = transform
                                    self.leftScreenImageView.transform = transform
                                    self.rightScreenImageView.transform = transform
                                   },
                                   completion: {_ in
                                    self.selectedPhoto += 1
                                    if self.selectedPhoto > self.fullScreenPhotos.count - 1 {
                                        self.selectedPhoto = 0
                                    }
                                    self.startAnimations()
                                   })
                    
                }
            )
            
        case .changed:
            let translationX = recognizer.translation(in: self.view).x
            
            if translationX > 0 {
                swipeToRight.fractionComplete = abs(translationX)/100
            } else {
                swipeToLeft.fractionComplete = abs(translationX)/100
            }
            
        case .ended:
            swipeToLeft.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            swipeToRight.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default:
            return
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
        if segue.identifier == "makeItBigger" {
            let extendedScreenVC = segue.destination as! ExtendedFullScreenViewController
            extendedScreenVC.currentPhoto = middleScreenImageView.image
        }
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "makeItBigger", sender: self)
    }
}

// MARK: - Extensions

extension FullScreenPhotosViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FlipPresentAnimationController(originFrame: middleScreenImageView.frame)
    }
    
    func animationController(forDismissed dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        guard dismissed is ExtendedFullScreenViewController else {
            return nil
        }
        return FlipDismissAnimationController(destinationFrame: middleScreenImageView.frame)
    }
}
