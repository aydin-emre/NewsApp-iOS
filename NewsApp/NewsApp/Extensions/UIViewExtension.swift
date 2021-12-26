//
//  UIViewExtension.swift
//  NewsApp
//
//  Created by Emre on 25.12.2021.
//

import UIKit

extension UIView {

    func round(_ radius: CGFloat = 8, _ masksToBounds: Bool = false) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = masksToBounds
    }

    func addBorder(_ color: UIColor, _ radius: CGFloat = 0, _ borderWidth: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = radius
    }

}
