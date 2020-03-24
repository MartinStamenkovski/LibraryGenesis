//
//  Book.swift
//  LibGen
//
//  Created by Martin Stamenkovski INS on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import Foundation

struct Book: Codable {
    
    let title: String
    let year: String?
    let author: String
    let language: String?
    let fileSize: String
    let md5: String
    let description: String?
    let coverURL: String?
    let publisher: String
    let pages: String
    let fileType: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case year
        case author
        case language
        case fileSize = "filesize"
        case md5
        case description = "descr"
        case coverURL = "coverurl"
        case publisher
        case pages
        case fileType = "extension"
    }
    
    var publisherOrEmpty: String {
        return publisher.isEmpty ? "N/A" : publisher
    }
    
    var descriptionOrEmpty: String {
        guard let description = self.description else { return "N/A" }
        return description.isEmpty ? "N/A" : description
    }
    
    var pagesOrEmpty: String {
        return pages.isEmpty ? "N/A" : pages
    }
}
