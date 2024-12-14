//
//  Event.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import Foundation

struct Event: Codable {
    let eventId: Int
    let eventLink: String
    let eventImage: String
    let youtuberProfileImage: String
    let eventEndDate: Date
    let eventTitle: String
    let eventDescription: String?
    var isLiked: Bool
    
    var dDay: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let endDate = calendar.startOfDay(for: eventEndDate)
        let components = calendar.dateComponents([.day], from: today, to: endDate)
        return components.day ?? 0
    }
}
