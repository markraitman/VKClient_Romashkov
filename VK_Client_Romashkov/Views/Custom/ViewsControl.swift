//
//  ViewsView.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 24.06.2021.
//

import UIKit

@IBDesignable
final class ViewsControl: UIControl {
    
    // MARK: - IBInspectable
    
    @IBInspectable
    var isViewed: Bool = false {
        didSet {
            updateViews()
        }
    }
    
    @IBInspectable
    var viewsCount: Int = 0 {
        didSet {
            countLabel.text = "\(viewsCount)"
        }
    }
    
    @IBInspectable
    var color: UIColor = .systemBlue {
        didSet {
            viewsButton.tintColor = .systemBlue
            countLabel.textColor = .systemBlue
        }
    }
    
    // MARK: - Subviews
    
    lazy var viewsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = color
        button.addTarget(self,
                         action: #selector(viewsButtonTapped),
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
        
        stackView.addArrangedSubview(viewsButton)
        stackView.addArrangedSubview(countLabel)
    }
    
    // MARK: - Actions
    
    @objc private func viewsButtonTapped(_ sender: UIButton) {
        isViewed.toggle()
        sendActions(for: .valueChanged)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [.curveEaseInOut],
                       animations: {self.countLabel.frame.origin.y += 10},
                       completion: nil)
    }
    
    private func updateViews() {
        let imageName = isViewed ? "eye.fill" : "eye"
        viewsButton.setImage(UIImage(systemName: imageName), for: .normal)
        viewsCount = isViewed ? viewsCount + 1 : viewsCount - 1
    }
    
}
