//
//  LikeControl.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 15.12.2020.
//

import UIKit


@IBDesignable
final class LikeControl: UIControl {
    
    // MARK: - IBInspectable
    
    @IBInspectable
    var isLiked: Bool = false {
        didSet {
            updateLike()
        }
    }
    
    @IBInspectable
    var likesCount: Int = 0 {
        didSet {
            countLabel.text = "\(likesCount)"
        }
    }
    
    @IBInspectable
    var color: UIColor = .lightGray {
        didSet {
            likeButton.tintColor = .red
            countLabel.textColor = .red
        }
    }
    
    // MARK: - Subviews
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = color
        button.addTarget(self,
                         action: #selector(likeButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = color
        label.text = "55"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
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
    
    // MARK: - Setup
    
    private func setup() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(countLabel)
    }
    
    // MARK: - Actions
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        isLiked.toggle()
        sendActions(for: .valueChanged)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {self.countLabel.frame.origin.y += 10},
                       completion: nil)
    }
    
    private func updateLike() {
        let imageName = isLiked ? "heart.fill" : "heart"
        likeButton.setImage(UIImage(systemName: imageName), for: .normal)
        likesCount = isLiked ? likesCount + 1 : likesCount - 1
        likeButton.tintColor = isLiked ? .red : .systemBlue
        countLabel.textColor = isLiked ? .red : .systemBlue
    }
    
}

