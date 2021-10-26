//
//  RepostsView.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 24.06.2021.
//

import UIKit

@IBDesignable
final class RepostsControl: UIControl {
    
    // MARK: - IBInspectable
    
    @IBInspectable
    var isReposted: Bool = false {
        didSet {
            updateRepost()
        }
    }
    
    @IBInspectable
    var repostsCount: Int = 0 {
        didSet {
            countLabel.text = "\(repostsCount)"
        }
    }
    
    @IBInspectable
    var color: UIColor = .systemBlue {
        didSet {
            repostsButton.tintColor = .systemBlue
            countLabel.textColor = .systemBlue
        }
    }
    
    // MARK: - Subviews
    
    lazy var repostsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        button.tintColor = color
        button.addTarget(self,
                         action: #selector(repostsButtonTapped),
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
        
        stackView.addArrangedSubview(repostsButton)
        stackView.addArrangedSubview(countLabel)
    }
    
    // MARK: - Actions
    
    @objc private func repostsButtonTapped(_ sender: UIButton) {
        isReposted.toggle()
        sendActions(for: .valueChanged)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {self.countLabel.frame.origin.y += 10},
                       completion: nil)
    }
    
    private func updateRepost() {
        let imageName = isReposted ? "arrowshape.turn.up.right.fill" : "arrowshape.turn.up.right"
        repostsButton.setImage(UIImage(systemName: imageName), for: .normal)
        repostsCount = isReposted ? repostsCount + 1 : repostsCount - 1
    }
    
}
