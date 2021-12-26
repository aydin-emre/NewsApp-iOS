//
//  HeadlinesViewModel.swift
//  NewsApp
//
//  Created by Emre on 26.12.2021.
//

import Foundation
import RxSwift
import RxCocoa

class HeadlinesViewModel {

    public let articles: PublishSubject<[Article]> = PublishSubject()
    public let error: PublishSubject<String> = PublishSubject()

    public func requestData(with sourceId: String) {
        let parameters = ["sources": sourceId]
        NetworkManager.shared.topHeadlines(with: parameters) { result in
            switch result {
            case .success(let response):
                self.articles.onNext(response.articles)
            case .failure(let error):
                self.error.onNext(error.localizedDescription)
            }
        }
    }

}
