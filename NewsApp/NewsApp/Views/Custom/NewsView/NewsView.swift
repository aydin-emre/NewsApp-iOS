//
//  NewsView.swift
//  NewsApp
//
//  Created by Emre on 26.12.2021.
//

import UIKit
import SDWebImage
import RealmSwift

class NewsView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addRemoveReadingListButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!

    @IBAction func addRemoveReadingListButton(_ sender: UIButton) {
        isNewsInList ? removeArticle() : saveArticle()
        isNewsInList = !isNewsInList
    }

    private let global = DispatchQueue.global(qos: .background)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
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
                if let urlToImage = article.urlToImage,
                   let url = URL(string: urlToImage) {
                    imageView.sd_setImage(with: url, completed: nil)
                }
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatterPrint.dateFormat = "HH:mm:ss"
                if let publishedAt = article.publishedAt,
                   let date = dateFormatterGet.date(from: publishedAt.standardizeDates()) {
                    dateLabel.text = dateFormatterPrint.string(from: date)
                }

                checkArticles()
            }
        }
    }

    public var isNewsInList: Bool = false {
        didSet {
            addRemoveReadingListButton.setTitle(isNewsInList ? "Okuma Listemden Kald??r" : "Okuma Listeme Ekle", for: .normal)
        }
    }

    func saveArticle() {
        global.sync {
            autoreleasepool {
                do {
                    if let realm = try? Realm(),
                       let article = self.article {
                        try? realm.write {
                            realm.add(article.detached())
                        }
                    }
                }
            }
        }
    }

    func removeArticle() {
        global.sync {
            autoreleasepool {
                do {
                    if let realm = try? Realm(),
                       let article = self.article {
                        if let articleToDelete = realm.objects(Article.self).filter({ $0.title == article.title }).first {
                            try? realm.write {
                                realm.delete(articleToDelete)
                            }
                        }
                    }
                }
            }
        }
    }

    func checkArticles() {
        global.sync {
            autoreleasepool {
                do {
                    if let realm = try? Realm(),
                       let article = self.article {
                        let isNewsInList = !realm.objects(Article.self).filter({ $0.title == article.title }).isEmpty
                        DispatchQueue.main.async {
                            self.isNewsInList = isNewsInList
                        }
                    }
                }
            }
        }
    }

}
