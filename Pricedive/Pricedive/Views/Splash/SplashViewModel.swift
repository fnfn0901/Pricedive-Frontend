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

    init(splashDuration: TimeInterval = 3.0) {
        self.splashDuration = splashDuration
    }

    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
            self.isSplashCompleted = true
        }
    }
}
