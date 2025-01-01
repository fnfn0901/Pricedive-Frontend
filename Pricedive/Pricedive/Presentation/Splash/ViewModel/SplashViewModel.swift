//
//  SplashViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import Foundation
import Combine

class SplashViewModel {
    @Published var isSplashCompleted: Bool = false
    private let splashDuration: TimeInterval
    private var cancellables = Set<AnyCancellable>()

    init(splashDuration: TimeInterval = 3.0) {
        self.splashDuration = splashDuration
    }

    func startSplashTimer(onComplete: (() -> Void)? = nil) {
        Just(true)
            .delay(for: .seconds(splashDuration), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isSplashCompleted = true
                onComplete?()
            }
            .store(in: &cancellables)
    }
}
