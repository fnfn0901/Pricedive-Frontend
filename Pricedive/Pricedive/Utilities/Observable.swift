//
//  Observable.swift
//  Pricedive
//
//  Created by 신호연 on 12/13/24.
//

import Foundation

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
