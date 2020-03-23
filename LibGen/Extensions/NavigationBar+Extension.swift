//
//  NavigationBar+Extension.swift
//  LibGen
//
//  Created by Martin Stamenkovski on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import UIKit
extension UINavigationBar {
    
    func transparent() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
    
    func removeTransparency() {
        self.shadowImage = nil
        self.setBackgroundImage(nil, for: .default)
    }
}


