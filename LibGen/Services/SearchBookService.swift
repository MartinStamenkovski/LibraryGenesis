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
        guard let url = self.buildURLComponents() else { return }
        self.loadBooks(from: url) { result in
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
    
    private func buildURLComponents() -> URL? {
        
        var urlComponents = URLComponents(url: .search, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "req", value: query),
            URLQueryItem(name: "phrase", value: "0"),
            URLQueryItem(name: "view", value: "simple"),
            URLQueryItem(name: "column", value: "def"),
            URLQueryItem(name: "sort", value: "def"),
            URLQueryItem(name: "sortmode", value: "ASC"),
            URLQueryItem(name: "page", value: String(page))
        ]
        return urlComponents?.url
    }
    
    func removeAll() {
        self.page = 1
        self.books.removeAll()
    }
    
    var isEmptySearch: Bool {
        return page == 1 && self.books.isEmpty
    }
}
