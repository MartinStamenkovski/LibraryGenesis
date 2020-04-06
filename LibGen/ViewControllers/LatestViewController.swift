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
    
    var loadingViewController: MSLoadingViewController!
    
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
        
        self.latestService = LatestBookService()
        self.latestService.delegate = self
        
        self.setupSnackbar()
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showLoading {
            self.latestService.fetchLatestBooks()
        }
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
                self.latestService.refreshBooks()
            }
        }
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
        self.dismissLoading {[weak self] in
            self?.removeLoadingFooter()
            self?.tableView.reloadData()
            self?.hideSnackbar()
        }
    }
    
    func didFailedLoadBooks(_ service: BookService, with error: LibError) {
        self.dismissLoading {[weak self] in
            self?.removeLoadingFooter()
            self?.onFailedLatestBooks(with: error)
        }
    }
    
    private func removeLoadingFooter() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {
            self.footerView.stopAnimating()
            self.tableView.tableFooterView = nil
        }, completion: nil)
    }
    
    private func onFailedLatestBooks(with error: LibError) {
        guard !self.latestService.isEndOfList(with: error) else { return }
        
        self.snackBar.message = error.localizedDescription
        self.bottomAnchorSnackbar.constant = -20
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    private func hideSnackbar() {
        guard self.bottomAnchorSnackbar.constant == -20 else { return }
        self.bottomAnchorSnackbar.constant = 500
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 7, options: [.curveEaseIn], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension LatestViewController {
    
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
