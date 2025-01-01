//
//  EventDetailViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import Foundation

class EventDetailViewModel {
    private let homeViewModel: HomeViewModel
    public let eventId: Int

    init(eventId: Int, homeViewModel: HomeViewModel) {
        self.eventId = eventId
        self.homeViewModel = homeViewModel
    }

    var eventLink: String? {
        return event?.eventLink
    }
    
    var eventTitle: String {
        return event?.eventTitle ?? ""
    }

    var eventDescription: String? {
        return event?.eventDescription
    }

    var eventEndDateText: String {
        guard let endDate = event?.eventEndDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: endDate)
    }

    var dDayText: String {
        return event?.dDayDescription ?? "종료"
    }

    var isLiked: Bool {
        return homeViewModel.isLiked(for: eventId)
    }

    var eventImageURL: URL? {
        guard let urlString = event?.eventImage else { return nil }
        return URL(string: urlString)
    }

    var youtuberProfileImageURL: URL? {
        guard let urlString = event?.youtuberProfileImage else { return nil }
        return URL(string: urlString)
    }

    func toggleLikeStatus() {
        homeViewModel.toggleLike(for: eventId)
    }

    private var event: Event? {
        return homeViewModel.events.first(where: { $0.eventId == eventId })
    }
}
