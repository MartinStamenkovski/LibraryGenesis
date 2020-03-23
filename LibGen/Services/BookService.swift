//
//  LatestService.swift
//  LibGen
//
//  Created by Martin Stamenkovski on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import Foundation
import SwiftSoup

protocol BookServiceDelegate: AnyObject {
    func didLoadBooks(_ service: BookService)
    func didFailedLoadBooks(_ service: BookService, with error: Error)
}

class BookService {
   
    weak var delegate: BookServiceDelegate?
        
    var page: Int = 1
    var books: [Book] = []
        
    func loadBooks(from url: URL, completion: @escaping((Result<[Book], Error>) -> Void)) {
        URLSession.shared.dataTask(with: url) { (data, res, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            if let data = data  {
                do {
                    var ids: [String?] = []
                    
                    let doc: Document = try SwiftSoup.parse(String(data: data, encoding: .utf8)!)
                    
                    let trArray = try doc.select("table.c tr").array()
                    for tr in trArray {
                        ids.append(try tr.select("td").array().first?.text())
                    }
                    
                    //We need to be sure that id is Int.
                    let parsedIDs = ids.compactMap { $0 }.compactMap { Int($0) }.map { String($0) }
                    self.getBooks(with: parsedIDs, completion: completion)
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
}
//MARK: - Get books with given ids.
extension BookService {
    
    private func getBooks(with ids: [String], completion: @escaping((Result<[Book], Error>) -> Void)) {
       
        var urlComponent = URLComponents(url: .baseURL, resolvingAgainstBaseURL: true)
        
        urlComponent?.queryItems = [
            URLQueryItem(name: "ids", value: ids.joined(separator: ",")),
            URLQueryItem(name: "fields", value: "*")
        ]
        
        guard let url = urlComponent?.url else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            if let data = data {
                self.decodeBooks(from: data, completion)
            }
        }.resume()
    }
    
    
    private func decodeBooks(from data: Data, _ completion: @escaping((Result<[Book], Error>) -> Void)) {
        let jsonDecoder = JSONDecoder()
        do {
            let books = try jsonDecoder.decode([Book].self, from: data)
            DispatchQueue.main.async {
                completion(.success(books))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
