//
//  Snackbar.swift
//  LibGen
//
//  Created by Martin Stamenkovski on 3/24/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import UIKit

class Snackbar: UIView {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    var labelMessage: UILabel =  {
        let label = UILabel()
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    var buttonAction: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.7), for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onRetryAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    var message: String? {
        willSet {
            self.labelMessage.text = newValue
        }
    }
    
    var onRetry: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        if #available(iOS 13.0, *) {
            self.backgroundColor = .secondarySystemBackground
        } else {
            self.backgroundColor = .lightGray
        }
        self.setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupShadow()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupSubviews() {
        
        self.addSubview(stackView)
        self.stackView.addArrangedSubview(labelMessage)
        self.stackView.addArrangedSubview(buttonAction)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.buttonAction.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupShadow() {
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 8
        self.layer.cornerRadius = 12
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
    }
    
    @objc
    private func onRetryAction(sender: UIButton) {
        self.onRetry?()
    }
}
