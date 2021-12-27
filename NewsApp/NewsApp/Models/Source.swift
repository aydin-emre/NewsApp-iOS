//
//  Source.swift
//  NewsApp
//
//  Created by Emre on 24.12.2021.
//

import Foundation
import RealmSwift

class Source: Object, Codable {

    @objc dynamic var id: String?
    @objc dynamic var name: String?
    @objc dynamic var sourceDescription: String?
    @objc dynamic var url: String?
    dynamic var category: Category?
    @objc dynamic var language: String?
    @objc dynamic var country: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case sourceDescription = "description"
        case url, category, language, country
    }

}
