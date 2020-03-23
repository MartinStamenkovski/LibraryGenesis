//
//  LatestViewController.swift
//  LibGen
//
//  Created by Martin Stamenkovski on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import UIKit

class LatestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var latestService: LatestBookService!
    
    lazy var footerView: LoadingFooterView = {
        let footerView = LoadingFooterView(frame: CGRect(origin: .zero, size: CGSize(width: self.tableView.bounds.width, height: 100)))
        return footerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.latestService = LatestBookService()
        self.latestService.delegate = self
        self.latestService.fetchLatestBooks()
        
        self.setupTableView()
    }
    
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: .bookTableViewCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
extension LatestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.latestService.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .bookTableViewCell, for: indexPath) as! BookTableViewCell
        cell.setup(with: self.latestService.books[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = self.latestService.books[indexPath.row]
        self.preview(book)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.latestService.lastIndex {
            self.footerView.startAnimating()
            self.tableView.tableFooterView = footerView
            self.latestService.loadNextPage()
        }
    }
}
extension LatestViewController: BookServiceDelegate {
    
    func didLoadBooks(_ service: BookService) {
        self.removeLoadingFooter()
        self.tableView.reloadData()
    }
    
    func didFailedLoadBooks(_ service: BookService, with error: Error) {
        self.removeLoadingFooter()
    }
    
    private func removeLoadingFooter() {
        self.footerView.stopAnimating()
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
}

extension LatestViewController {
    
    private func preview(_ book: Book) {
        let detailStoryboard = UIStoryboard(name: "Detail", bundle: nil)
        let detailsViewController = detailStoryboard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
        detailsViewController.book = book
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
