//
//  Source.swift
//  NewsApp
//
//  Created by Emre on 24.12.2021.
//

import Foundation

struct Source: Codable {

    let id: String?
    let name: String?
    let sourceDescription: String?
    let url: String?
    var category: Category?
    let language: String?
    let country: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case sourceDescription = "description"
        case url, category, language, country
    }

}