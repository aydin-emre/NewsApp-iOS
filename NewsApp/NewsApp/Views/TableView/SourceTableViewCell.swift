//
//  SourceTableViewCell.swift
//  NewsApp
//
//  Created by Emre on 24.12.2021.
//

import UIKit

class SourceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func configure(with source: Source) {
        titleLabel.text = source.name
        descriptionLabel.text = source.sourceDescription
    }

}
