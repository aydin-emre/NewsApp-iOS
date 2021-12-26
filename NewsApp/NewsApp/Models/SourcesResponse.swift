//
//  SourcesResponse.swift
//  NewsApp
//
//  Created by Emre on 24.12.2021.
//

import Foundation

struct SourcesResponse: Codable {

    let status: String?
    let sources: [Source]?
    let code: String?
    let message: String?

}
