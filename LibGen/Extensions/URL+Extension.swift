//
//  URL+Extension.swift
//  LibGen
//
//  Created by Martin Stamenkovski on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import Foundation

extension URL {
    
    static let baseURL = URL(string: "http://gen.lib.rus.ec/json.php")!
    
    static func latestURLHTML(with page: Int) -> URL {
        return URL(string: "http://gen.lib.rus.ec/search.php?mode=last&view=simple&column=def&sort=def&sortmode=ASC&page=\(page)")!
    }
    
    static func search(with query: String, and page: Int) -> URL {
        return URL(string: "http://gen.lib.rus.ec/search.php?&req=\(query)&phrase=0&view=simple&column=def&sort=def&sortmode=ASC&page=\(page)")!
    }
    
    static func image(with url: String?) -> URL? {
        guard let url = url else { return nil }
        return URL(string: "http://gen.lib.rus.ec/covers/\(url)")!
    }
}
