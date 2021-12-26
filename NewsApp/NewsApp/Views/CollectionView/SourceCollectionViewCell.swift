//
//  SourceCollectionViewCell.swift
//  NewsApp
//
//  Created by Emre on 25.12.2021.
//

import UIKit

class SourceCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        self.round()
        self.addBorder(.black, 8, 0.5)
        setSelected(false)
    }

    func configure(with category: Category, _ isSelected: Bool) {
        label.text = category.rawValue.capitalized
        setSelected(isSelected)
    }

    func setSelected(_ isSelected: Bool) {
        backgroundColor = isSelected ? .black : .white
        label.textColor = isSelected ? .white : .black
        imageView.tintColor = isSelected ? .white : .black
        if #available(iOS 13.0, *) {
            imageView.image = isSelected ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        }
    }

}
