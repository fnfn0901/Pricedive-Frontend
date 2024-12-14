//
//  MyPageViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import Foundation

class MyPageViewModel {
    @Published var events: [Event]
    
    init(events: [Event] = []) {
        self.events = events
    }
}
