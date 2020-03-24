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
    private var loadingViewController: MSLoadingViewController!
    
    private var bookService: SearchBookService!
    
    lazy var footerView: LoadingFooterView = {
        let footerView = LoadingFooterView(frame: CGRect(origin: .zero, size: CGSize(width: self.tableView.bounds.width, height: 80)))
        return footerView
    }()
    
    private var snackBar: Snackbar = {
        let snackBar = Snackbar()
        snackBar.translatesAutoresizingMaskIntoConstraints = false
        return snackBar
    }()
    
    private var bottomAnchorSnackbar: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bookService = SearchBookService()
        self.bookService.delegate = self
        
        self.setupTableView()
        self.setupSnackbar()
        
        self.setupSearchController()
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: .bookTableViewCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupSnackbar() {
        self.view.addSubview(snackBar)
        if #available(iOS 11.0, *) {
            self.bottomAnchorSnackbar =  self.snackBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 500)
        } else {
            self.bottomAnchorSnackbar =  self.snackBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 500)
        }
        self.bottomAnchorSnackbar.isActive = true
        
        NSLayoutConstraint.activate([
            self.snackBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.snackBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.snackBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
        
        self.snackBar.onRetry = {[unowned self] in
            self.showLoading {
                self.bookService.refreshBooks()
            }
        }
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
            self.loadNextPage()
        }
    }
}

extension SearchBookViewController: BookServiceDelegate {
    
    func didLoadBooks(_ service: BookService) {
        self.dismissLoading {[weak self] in
            self?.hideSnackbar()
            self?.tableView.reloadData()
            self?.removeLoadingFooter()
        }
    }
    
    func didFailedLoadBooks(_ service: BookService, with error: LibError) {
        self.dismissLoading {[weak self] in
            self?.removeLoadingFooter()
            self?.onSearchError(with: error)
        }
    }
    
    private func removeLoadingFooter() {
       self.footerView.stopAnimating()
       self.tableView.tableFooterView = nil
    }
    
    private func loadNextPage() {
        self.footerView.startAnimating()
        self.tableView.tableFooterView = footerView
        self.bookService.loadNextPage()
    }
    
    private func onSearchError(with error: LibError) {
        guard !self.bookService.isEndOfList(with: error) else { return }
        
        self.snackBar.message = error.localizedDescription
        self.bottomAnchorSnackbar.constant = -20
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    private func hideSnackbar() {
        guard self.bottomAnchorSnackbar.constant == -20 else { return }
        self.bottomAnchorSnackbar.constant = 500
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
        self.definesPresentationContext = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        self.bookService.removeAll()
        self.tableView.reloadData()
        
        self.showLoading {
            self.bookService.searchBooks(with: query)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         self.hideSnackbar()
    }

}

extension SearchBookViewController {
    
    private func preview(_ book: Book) {
        let detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
        let detailsViewController = detailStoryboard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        detailsViewController.book = book
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    private func showLoading(_ completion: @escaping (() -> Void)) {
        self.loadingViewController = MSLoadingViewController()
        self.loadingViewController.message = "Fetching books..."
        self.present(loadingViewController, animated: true, completion: completion)
    }
    
    private func dismissLoading(_ completion: @escaping (() -> Void)) {
        guard let loadingViewController = self.loadingViewController else {
            completion()
            return
        }
        loadingViewController.dismiss(animated: true, completion: completion)
        self.loadingViewController = nil
    }
}
