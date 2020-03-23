//
//  LatestBookService.swift
//  LibGen
//
//  Created by Martin Stamenkovski on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import Foundation

class LatestBookService: BookService {
    
    private var isLoading = false
    
    func fetchLatestBooks(with page: Int = 1) {
        self.loadBooks(from: .latestURLHTML(with: page)) { result in
            switch result {
            case .success(let books):
                self.books.append(contentsOf: books)
                self.page += 1
                self.delegate?.didLoadBooks(self)
                break
            case .failure(let error):
                self.delegate?.didFailedLoadBooks(self, with: error)
                break
            }
            self.isLoading = false
        }
    }
    
    func loadNextPage() {
        guard !isLoading else { return }
        self.isLoading = true
        self.fetchLatestBooks(with: page)
    }
    
    var lastIndex: Int {
        return self.books.count - 1
    }
}
