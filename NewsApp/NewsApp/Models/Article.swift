//
//  Article.swift
//  NewsApp
//
//  Created by Emre on 26.12.2021.
//

import Foundation

struct Article: Codable {

    let source: Source?
    let author: String?
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }

}
