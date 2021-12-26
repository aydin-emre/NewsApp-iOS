//
//  NewsView.swift
//  NewsApp
//
//  Created by Emre on 26.12.2021.
//

import UIKit
import SDWebImage

class NewsView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addRemoveReadingListButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!

    @IBAction func addRemoveReadingListButton(_ sender: UIButton) {
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("NewsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    let dateFormatterGet = DateFormatter()
    let dateFormatterPrint = DateFormatter()
    public var article: Article? {
        didSet {
            if let article = article {
                titleLabel.text = article.title
                if let url = URL(string: article.urlToImage) {
                    imageView.sd_setImage(with: url, completed: nil)
                }
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatterPrint.dateFormat = "HH:mm:ss"
                if let date = dateFormatterGet.date(from: article.publishedAt) {
                    dateLabel.text = dateFormatterPrint.string(from: date)
                }
            }
        }
    }

}
