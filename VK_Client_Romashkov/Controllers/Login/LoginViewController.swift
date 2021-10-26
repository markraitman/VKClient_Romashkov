//
//  ViewController.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 15.10.2020.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Life cycle
    
    override func viewWillLayoutSubviews() {
        animateVKMainLogoAppearing()
        animateFieldsAppearing()
        animateLabelsAppearing()
        animateLogInButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)
        
        let hideKeyboardGesture = UITapGestureRecognizer (target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var vkMainLogo: UIImageView!
    @IBOutlet weak var connect: UILabel!
    @IBOutlet weak var facebook: UILabel!
    @IBOutlet weak var vk_logo: UIImageView!
    @IBOutlet weak var fb_logo: UIImageView!
    @IBOutlet weak var quwstionMark_logo: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    // MARK: - Keyboard actions
    
    @objc func keyboardWasShown (notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets (top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.scrollView?.contentInset = contentInsets
    }
    
    @objc func keyboardWillBeHidden (notification: Notification){
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideKeyboard(){
        self.scrollView?.endEditing(true)
    }
    
    // MARK: - Password actions
    
    @IBAction func loginButtonPressed (_ sender: UIButton){
        guard userDataIsRight() else {
            showEnterError()
            return
        }
        
        performSegue(withIdentifier: "fromLoginViewController", sender: self)
    }
    
    func userDataIsRight () -> Bool{
        guard let login = emailTextField.text else {
            return false
        }
        guard let password = passwordTextField.text else {
            return false
        }
        
        return login == "" && password == ""
    }
    
    func showEnterError(){
        let alert = UIAlertController(
            title: "Ошибка!",
            message: "Неверный логин или пароль!",
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "Ok!",
            style: .default)
            alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Animations
    
    var interactiveAnimator: UIViewPropertyAnimator!
    @objc func onPan(_ recognizer: UIPanGestureRecognizer){
        switch recognizer.state {
        case .began:
            interactiveAnimator?.startAnimation()
            
            interactiveAnimator = UIViewPropertyAnimator(duration: 0.5,
                                                         dampingRatio: 0.5,
                                                         animations: {
                                                            self.logInButton.transform = CGAffineTransform(translationX: 0, y: 200)
                                                         })
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            interactiveAnimator.fractionComplete = translation.y / 100
        case .ended:
            interactiveAnimator.stopAnimation(true)
            interactiveAnimator.addAnimations {
                self.logInButton.transform = .identity
            }
            interactiveAnimator.startAnimation()
        default: return
        }
    }
    
    func animateLogInButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.logInButton.layer.add(animation, forKey: nil)
    }
    
    func animateVKMainLogoAppearing() {
        self.vkMainLogo.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height/2)
        
        let mainLogoAnimator = UIViewPropertyAnimator(duration: 1,
                                                      dampingRatio: 0.5,
                                                      animations: {self.vkMainLogo.transform = .identity})
        mainLogoAnimator.startAnimation(afterDelay: 1)
    }
 
    func animateFieldsAppearing() {
        let offset = abs(self.emailTextField.frame.midY - self.passwordTextField.frame.midY)
        self.emailTextField.transform = CGAffineTransform(translationX: 0, y: offset)
        self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: -offset)
        
        UIView.animateKeyframes(withDuration: 1,
                                delay: 1,
                                options: .calculationModeCubicPaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        self.emailTextField.transform = CGAffineTransform(translationX: 150, y: 50)
                                                        self.passwordTextField.transform = CGAffineTransform(translationX: -150, y: -50)
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                        self.emailTextField.transform = .identity
                                                        self.passwordTextField.transform = .identity
                                                       })
                                },
                                completion: nil)
    }
    
    func animateLabelsAppearing() {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.stiffness = 200
        scaleAnimation.mass = 2
        
        let animationsGroup = CAAnimationGroup()
        animationsGroup.duration = 1
        animationsGroup.beginTime = CACurrentMediaTime() + 1
        animationsGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animationsGroup.fillMode = CAMediaTimingFillMode.backwards
        animationsGroup.animations = [fadeInAnimation, scaleAnimation]
        
        self.connect.layer.add(animationsGroup, forKey: nil)
        self.facebook.layer.add(animationsGroup, forKey: nil)
        self.vk_logo.layer.add(animationsGroup, forKey: nil)
        self.fb_logo.layer.add(animationsGroup, forKey: nil)
    }
}
