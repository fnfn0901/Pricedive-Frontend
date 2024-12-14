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
    @Published var events: [Event] = []
    private var allEvents: [Event]
    private var cancellables = Set<AnyCancellable>()

    init(events: [Event]) {
        self.allEvents = events
        self.events = events
        setupBindings()
    }

    private func setupBindings() {
        $searchQuery
            .map { [weak self] query in
                self?.allEvents.filter { query.isEmpty || $0.eventTitle.contains(query) } ?? []
            }
            .sink { [weak self] filtered in
                self?.events = filtered
            }
            .store(in: &cancellables)
    }

    func toggleLike(for eventId: Int) {
        guard let index = allEvents.firstIndex(where: { $0.eventId == eventId }) else { return }
        allEvents[index].isLiked.toggle()
        events = allEvents
    }

    func isLiked(for eventId: Int) -> Bool {
        return allEvents.first(where: { $0.eventId == eventId })?.isLiked ?? false
    }
}
