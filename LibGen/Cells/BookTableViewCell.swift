//
//  BookTableViewCell.swift
//  LibGen
//
//  Created by Martin Stamenkovski on 3/23/20.
//  Copyright © 2020 Stamenkovski. All rights reserved.
//

import UIKit
import Kingfisher

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCover: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageViewCover.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with book: Book) {
        self.labelTitle.text = book.title
        self.labelAuthor.text = book.author
        self.labelYear.text = book.year
        self.imageViewCover.kf.setImage(with: URL.image(with: book.coverURL))
    }
}
