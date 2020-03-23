//
//  SearchBookService.swift
//  LibGen
//
//  Created by Martin Stamenkovski on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import Foundation

class SearchBookService: BookService {
    
        
    private var isLoading = false
    
    private var query: String!
    
    func searchBooks(with query: String, and page: Int = 1) {
        self.query = query
        self.loadBooks(from: .search(with: query, and: page)) { result in
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
        self.searchBooks(with: query, and: page)
    }
    
    var lastIndex: Int {
        return self.books.count - 1
    }
}
