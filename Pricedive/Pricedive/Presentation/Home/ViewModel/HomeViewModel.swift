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
    private var likedEvents = Set<Int>()

    init(events: [Event]) {
        self.allEvents = events
        self.events = events
        setupBindings()
    }

    private func setupBindings() {
        $searchQuery
            .map { [weak self] query in
                self?.allEvents.filter {
                    query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                    $0.eventTitle.range(of: query, options: .caseInsensitive) != nil
                } ?? []
            }
            .sink { [weak self] filtered in
                self?.events = filtered
            }
            .store(in: &cancellables)
    }

    func toggleLike(for eventId: Int) {
        if likedEvents.contains(eventId) {
            likedEvents.remove(eventId)
            print("Event \(eventId) removed from liked events.") // 디버그 로그
        } else {
            likedEvents.insert(eventId)
            print("Event \(eventId) added to liked events.") // 디버그 로그
        }
    }

    func isLiked(for eventId: Int) -> Bool {
        let result = likedEvents.contains(eventId)
        print("Checking isLiked for event \(eventId): \(result)") // 디버그 로그
        return result
    }
}
