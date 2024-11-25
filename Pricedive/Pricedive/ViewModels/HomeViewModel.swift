//
//  HomeViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import Foundation

class HomeViewModel {
    let titleText = Observable<String>("Welcome to Home")
}

class Observable<T> {
    var value: T {
        didSet {
            observer?(value)
        }
    }

    private var observer: ((T) -> Void)?

    init(_ value: T) {
        self.value = value
    }

    func bind(observer: @escaping (T) -> Void) {
        self.observer = observer
        observer(value)
    }
}
