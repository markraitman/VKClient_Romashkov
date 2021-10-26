//
//  CommentsView.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 24.06.2021.
//

import UIKit

@IBDesignable
final class CommentsControl: UIControl {
    
    // MARK: - IBInspectable
    
    @IBInspectable
    var isCommented: Bool = false {
        didSet {
            updateComment()
        }
    }
    
    @IBInspectable
    var commentsCount: Int = 0 {
        didSet {
            countLabel.text = "\(commentsCount)"
        }
    }
    
    @IBInspectable
    var color: UIColor = .systemBlue {
        didSet {
            commentsButton.tintColor = .systemBlue
            countLabel.textColor = .systemBlue
        }
    }
    
    // MARK: - Subviews
    
    lazy var commentsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        button.tintColor = color
        button.addTarget(self,
                         action: #selector(commentsButtonTapped),
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
        
        stackView.addArrangedSubview(commentsButton)
        stackView.addArrangedSubview(countLabel)
    }
    
    // MARK: - Actions
    
    @objc private func commentsButtonTapped(_ sender: UIButton) {
        isCommented.toggle()
        sendActions(for: .valueChanged)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {self.countLabel.frame.origin.y += 10},
                       completion: nil)
    }
    
    private func updateComment() {
        let imageName = isCommented ? "text.bubble.fill" : "text.bubble"
        commentsButton.setImage(UIImage(systemName: imageName), for: .normal)
        commentsCount = isCommented ? commentsCount + 1 : commentsCount - 1
    }
    
}
