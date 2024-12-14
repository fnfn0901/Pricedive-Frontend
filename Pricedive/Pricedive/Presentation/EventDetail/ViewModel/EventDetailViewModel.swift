//
//  EventDetailViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import Foundation

class EventDetailViewModel {
    private var event: Event

    init(event: Event) {
        self.event = event
    }

    var eventTitle: String {
        return event.eventTitle
    }

    var eventDescription: String? {
        return event.eventDescription
    }

    var eventEndDateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: event.eventEndDate)
    }

    var dDayText: String {
        let dDay = event.dDay
        return dDay > 0 ? "\(dDay)" : "Event Ended"
    }

    var isLiked: Bool {
        return event.isLiked ?? false
    }

    var eventImageURL: URL? {
        return URL(string: event.eventImage)
    }

    var youtuberProfileImageURL: URL? {
        return URL(string: event.youtuberProfileImage)
    }

    func toggleLikeStatus() {
        event.isLiked?.toggle()
    }
}
