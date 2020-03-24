//
//  String+Extension.swift
//  LibGen
//
//  Created by Martin Stamenkovski INS on 3/24/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import Foundation

extension String {
    
    var html: String {
        let data = Data(self.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString.string
        }
        return self
    }
}
