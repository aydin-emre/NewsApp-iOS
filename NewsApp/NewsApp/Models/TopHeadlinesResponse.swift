//
//  TopHeadlinesResponse.swift
//  NewsApp
//
//  Created by Emre on 26.12.2021.
//

import Foundation

struct TopHeadlinesResponse: Codable {

    let status: String
    let totalResults: Int
    let articles: [Article]

}
