//
//  Event.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import Foundation

struct Event: Codable {
    let eventId: Int?
    let videoId: Int?
    let eventLink: String
    let eventImage: String
    let channelImg: String
    let eventEndDate: String
    let eventItem: String
    let eventDescription: String?

    /// ✅ eventEndDate(String)를 Date로 변환하는 계산 속성
    var eventEndDateAsDate: Date? {
        return Event.dateFormatter.date(from: eventEndDate)
    }

    /// ✅ D-day 계산을 위한 DateFormatter
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()

    /// ✅ D-day 계산 로직
    var dDay: Int {
        guard let endDate = eventEndDateAsDate else { return 0 }
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0
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
