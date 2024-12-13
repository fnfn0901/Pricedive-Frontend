//
//  HomeViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import Combine
import Foundation

class HomeViewModel {
    @Published var searchQuery: String = ""
    let events = CurrentValueSubject<[Event], Never>([])
    private let allEvents: [Event]
    private var cancellables = Set<AnyCancellable>()

    init(events: [Event]) {
        self.allEvents = events
        setupBindings()
    }

    private func setupBindings() {
        $searchQuery
            .map { [weak self] query in
                self?.allEvents.filter { query.isEmpty || $0.eventTitle.contains(query) } ?? []
            }
            .sink { [weak self] filtered in
                self?.events.send(filtered)
            }
            .store(in: &cancellables)
    }
}
