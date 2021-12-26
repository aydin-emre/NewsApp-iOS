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
    public let error: PublishSubject<NetworkError> = PublishSubject()

    public func requestData() {
        NetworkManager.shared.sources { result in
            switch result {
            case .success(let sourcesResponse):
                self.sources.onNext(sourcesResponse.sources)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }

}
