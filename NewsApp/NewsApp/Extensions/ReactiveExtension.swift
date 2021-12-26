//
//  ReactiveExtension.swift
//  NewsApp
//
//  Created by Emre on 25.12.2021.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {

    public func modelAndIndexSelected<T>(_ modelType: T.Type) -> ControlEvent<(T, IndexPath)> {
        ControlEvent(events: Observable.zip(
            self.modelSelected(modelType),
            self.itemSelected
        ))
    }

}
