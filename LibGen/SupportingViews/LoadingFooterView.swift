//
//  LoadingFooterView.swift
//  LibGen
//
//  Created by Martin Stamenkovski on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import UIKit

class LoadingFooterView: UIView {

    var indicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .medium)
            indicator.color = .systemBlue
        } else {
            indicator = UIActivityIndicatorView(style: .white)
            indicator.color = .blue
        }
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(indicator)
        NSLayoutConstraint.activate([
            self.indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopAnimating() {
        if self.indicator.isAnimating {
            self.indicator.stopAnimating()
        }
    }
    
    func startAnimating() {
        self.indicator.startAnimating()
    }
}
