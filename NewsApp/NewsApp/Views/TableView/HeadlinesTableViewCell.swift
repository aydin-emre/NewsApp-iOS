//
//  HeadlinesTableViewCell.swift
//  NewsApp
//
//  Created by Emre on 26.12.2021.
//

import UIKit

class HeadlinesTableViewCell: UITableViewCell {

    @IBOutlet weak var newsView: NewsView!

    func configure(with article: Article) {
        newsView.article = article
    }

}
