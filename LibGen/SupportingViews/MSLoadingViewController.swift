//
//  LoadingViewController.swift
//  MSUIKit
//
//  Created by Martin on 11/30/19.
//  Copyright © 2019 martinstamenkovski. All rights reserved.
//

import UIKit

public final class MSLoadingViewController: UIViewController {
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    private var width: CGFloat!
    private var height: CGFloat!
    
    public var message: String = "Please wait..." {
        willSet {
            self.loadingView.labelDescription.text = newValue
        }
    }
    
    public var indicatorColor: UIColor! {
        willSet {
            self.loadingView.loadingIndicator.color = newValue
        }
    }
    
    public var hasBlurEffect: Bool = false
    
    private var blurEffectView: UIVisualEffectView!
    
    public init(width: CGFloat = 150, height: CGFloat = 100) {
        super.init(nibName: nil, bundle: nil)
        self.width = width
        self.height = height
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackground()
        self.setupSubview()
    }
    
    
    private func setupSubview() {
        self.view.addSubview(self.loadingView)
        
        self.loadingView.layer.cornerRadius = 8
        
        let constraints = [
            self.loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.loadingView.widthAnchor.constraint(equalToConstant: width),
            self.loadingView.heightAnchor.constraint(equalToConstant: height),
        ]
        loadingView.labelDescription.text = self.message
        NSLayoutConstraint.activate(constraints)
        
        self.setupLoadingViewColor()
        self.setupLoadingViewShadow()
    }
    // MARK: - Background color OR blur effect
    private func setupBackground() {
        if hasBlurEffect {
            self.setupBlurEffectView()
        } else {
            if #available(iOS 13.0, *) {
                self.view.backgroundColor = UIColor.tertiarySystemFill.withAlphaComponent(0.3)
            } else {
                self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            }
        }
    }
    //MARK: - LoadingView Background color
    private func setupLoadingViewColor() {
        if #available(iOS 13.0, *) {
            self.loadingView.backgroundColor = .systemBackground
        } else {
            self.loadingView.backgroundColor = .white
        }
    }
    //MARK: - LoadingView Shadow color
    private func setupLoadingViewShadow() {
        
        if #available(iOS 13.0, *) {
            self.loadingView.layer.shadowColor = UIColor.secondaryLabel.cgColor
        } else {
            self.loadingView.layer.shadowColor = UIColor.lightGray.cgColor
        }
        self.loadingView.layer.shadowOpacity = 0.5
        self.loadingView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}


//MARK: - BlurEffect setup
extension MSLoadingViewController {
    
    func setupBlurEffectView() {
        let blurEffect: UIBlurEffect
        let blurAlpha: CGFloat
        if #available(iOS 13.0, *) {
            blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
            blurAlpha = 0.8
        } else {
            blurEffect = UIBlurEffect(style: .dark)
            blurAlpha = 0.4
        }
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView.alpha = blurAlpha
        self.blurEffectView.frame = self.view.bounds
        self.view.insertSubview(blurEffectView, at: 0)
    }
    
}

//MARK: - LoadingView
private final class LoadingView: UIView {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            loadingIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            loadingIndicator = UIActivityIndicatorView(style: .gray)
        }
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        loadingIndicator.color = .systemBlue
        return loadingIndicator
    }()
    
    let labelDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviews()
    }
    
    
    func setupSubviews() {
        
        self.stackView.addArrangedSubview(self.loadingIndicator)
        self.stackView.addArrangedSubview(self.labelDescription)
        
        self.addSubview(self.stackView)
        
        let constraints = [
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

