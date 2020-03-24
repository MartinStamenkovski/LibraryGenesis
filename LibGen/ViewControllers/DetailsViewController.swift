//
//  DetailsViewController.swift
//  LibGen
//
//  Created by Martin Stamenkovski INS on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewHeader: UIImageView!
    
    @IBOutlet weak var buttonExpandDescription: UIButton!
    @IBOutlet weak var buttonDownload: UIButton!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelPublisher: UILabel!
    @IBOutlet weak var labelPages: UILabel!
    @IBOutlet weak var labelFileType: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var imageViewHeaderHeight: NSLayoutConstraint!
    private var imageViewHeaderOriginalHeight: CGFloat!
    
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBookData()
        self.setupStretchyHeader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.transparent()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.removeTransparency()
    }
    
    private func setupStretchyHeader() {
        self.imageViewHeaderOriginalHeight = self.imageViewHeaderHeight.constant
        self.scrollView.delegate = self
        self.scrollView.contentInset = .init(top: self.imageViewHeaderOriginalHeight, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction
    func actionExpandDescription(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            if self.labelDescription.numberOfLines == 3 {
                self.labelDescription.numberOfLines = 0
                self.buttonExpandDescription.transform = CGAffineTransform(rotationAngle: .pi)
            } else {
                self.labelDescription.numberOfLines = 3
                self.buttonExpandDescription.transform = .identity
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction
    func actionDownload(_ sender: UIButton) {
        Alert.showMirrors(on: self, sourceView: self.buttonDownload, for: book.md5) { url in
            if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url)
            } else {
                Alert.urlError(on: self)
            }
        }
    }
    
    private func setupBookData() {
        self.imageViewHeader.kf.setImage(with: URL.image(with: book.coverURL))
        self.labelTitle.text = book.title
        self.labelYear.text = book.year
        self.labelAuthor.text = book.author
        self.labelLanguage.text = book.language
        self.labelPublisher.text = book.publisherOrEmpty
        self.labelPages.text = book.pagesOrEmpty
        self.labelFileType.text = book.fileType
        self.labelDescription.text = book.descriptionOrEmpty
    }
}

extension DetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = self.imageViewHeaderOriginalHeight - (scrollView.contentOffset.y  + self.imageViewHeaderOriginalHeight)
        let height = min(max(y, 100), UIScreen.main.bounds.height)
        self.imageViewHeaderHeight.constant = height
    }
}

