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
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: eventEndDate).day ?? 0
        return daysLeft
    }
    
    var dDayDescription: String {
        if dDay > 0 {
            return "D-\(dDay)"
        } else if dDay == 0 {
            return "D-day"
        } else {
            return "종료"
        }
    }
}
