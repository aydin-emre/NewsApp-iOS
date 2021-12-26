//
//  StringExtension.swift
//  NewsApp
//
//  Created by Emre on 26.12.2021.
//

import Foundation

extension String {

    func standardizeDates() -> String {
        return self.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
    }

}
