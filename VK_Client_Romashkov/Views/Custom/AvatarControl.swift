//
//  FriendAvatar.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 10.12.2020.
//

import UIKit

@IBDesignable
final class AvatarControl: UIView {
    
    // MARK: - Properties
    
    @IBInspectable
    var image: UIImage? {
        didSet {
            avatarImageView.image = image
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat = 0 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float = 1 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor = .black {
        didSet {
            updateShadow()
        }
    }
    
    // MARK: - Subviews
    
    lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return avatarImageView
    }()
    
    lazy var avatarShadowView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(avatarShadowView)
        addSubview(avatarImageView)
        
        avatarShadowView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarShadowView.topAnchor.constraint(equalTo: topAnchor),
            avatarShadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatarShadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarShadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self,
                                      action: #selector(viewTapped))
        addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarShadowView.layer.cornerRadius = avatarShadowView.frame.width / 2
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    private func updateShadow() {
        avatarShadowView.layer.shadowRadius = shadowRadius
        avatarShadowView.layer.shadowColor = shadowColor.cgColor
        avatarShadowView.layer.shadowOpacity = shadowOpacity
    }
    
    @objc private func viewTapped(sender: UIGestureRecognizer) {
        transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {self.transform = .identity},
                       completion: nil)
            
    }
    
}
