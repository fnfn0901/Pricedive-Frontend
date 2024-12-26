//
//  LikeViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import Foundation

class LikeViewModel {
    @Published var events: [Event]
    
    init(events: [Event] = []) {
        self.events = events
    }
}
