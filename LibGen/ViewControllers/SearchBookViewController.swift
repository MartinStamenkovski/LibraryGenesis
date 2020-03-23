//
//  SearchBookViewController.swift
//  LibGen
//
//  Created by Martin Stamenkovski INS on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import UIKit

class SearchBookViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var searchController: UISearchController!
    
    private var bookService: SearchBookService!
    
    lazy var footerView: LoadingFooterView = {
        let footerView = LoadingFooterView(frame: CGRect(origin: .zero, size: CGSize(width: self.tableView.bounds.width, height: 100)))
        return footerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bookService = SearchBookService()
        self.bookService.delegate = self
        
        self.setupTableView()
        self.setupSearchController()
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: .bookTableViewCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

extension SearchBookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookService.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .bookTableViewCell, for: indexPath) as! BookTableViewCell
        cell.setup(with: self.bookService.books[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.preview(self.bookService.books[indexPath.row])
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.bookService.lastIndex {
            self.footerView.startAnimating()
            self.tableView.tableFooterView = footerView
            self.bookService.loadNextPage()
        }
    }
}

extension SearchBookViewController: BookServiceDelegate {
    
    func didLoadBooks(_ service: BookService) {
        self.tableView.reloadData()
        self.removeLoadingFooter()
    }
    
    func didFailedLoadBooks(_ service: BookService, with error: Error) {
        self.removeLoadingFooter()
        print(error)
    }
    
    private func removeLoadingFooter() {
        self.footerView.stopAnimating()
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension SearchBookViewController: UISearchBarDelegate {
    
    private func setupSearchController() {
        
        guard self.searchController == nil else { return }
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.placeholder = "Search by title, author..."
        self.searchController.searchBar.delegate = self
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.searchController = searchController
        } else {
            self.tableView.tableHeaderView = searchController.searchBar
        }
        self.searchController.obscuresBackgroundDuringPresentation = false
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.bookService.removeAll()
        self.tableView.reloadData()
        
        self.bookService.searchBooks(with: query)
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarResultsListButtonClicked")
    }
}

extension SearchBookViewController {
    
    private func preview(_ book: Book) {
        let detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
        let detailsViewController = detailStoryboard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        detailsViewController.book = book
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
