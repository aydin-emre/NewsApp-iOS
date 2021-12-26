//
//  SourcesViewModel.swift
//  NewsApp
//
//  Created by Emre on 24.12.2021.
//

import Foundation
import RxSwift
import RxCocoa

class SourcesViewModel {

    public let sources: PublishSubject<[Source]> = PublishSubject()
    public let error: PublishSubject<String> = PublishSubject()

    public func requestData() {
        NetworkManager.shared.sources { result in
            switch result {
            case .success(let response):
                if let sources = response.sources {
                    self.sources.onNext(sources)
                } else if let message = response.message {
                    self.error.onNext(message)
                }
            case .failure(let error):
                self.error.onNext(error.localizedDescription)
            }
        }
    }

}
