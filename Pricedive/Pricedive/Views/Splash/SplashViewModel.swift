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

    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3000) {
            self.isSplashCompleted = true
        }
    }
}
