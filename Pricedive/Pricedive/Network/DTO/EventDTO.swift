//
//  EventDTO.swift
//  Pricedive
//
//  Created by 신호연 on 2/12/25.
//

import Foundation

struct EventDTO: Decodable {
    let eventId: Int
    let category: String
    let eventNums: Int
    let eventItem: String
    var previewImg: String
    let videoId: Int?
    let dateEnd: String

    enum CodingKeys: String, CodingKey {
        case eventId, category, eventNums, eventItem, previewImg, videoId, dateEnd
    }

    init(eventId: Int, category: String, eventNums: Int, eventItem: String, previewImg: String, videoId: Int?, dateEnd: String) {
        self.eventId = eventId
        self.category = category
        self.eventNums = eventNums
        self.eventItem = eventItem
        self.previewImg = EventDTO.formatImageURL(previewImg)
        self.videoId = videoId
        self.dateEnd = dateEnd
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventId = try container.decode(Int.self, forKey: .eventId)
        category = try container.decode(String.self, forKey: .category)
        eventNums = try container.decode(Int.self, forKey: .eventNums)
        eventItem = try container.decode(String.self, forKey: .eventItem)
        previewImg = try container.decode(String.self, forKey: .previewImg)
        videoId = try container.decodeIfPresent(Int.self, forKey: .videoId)
        dateEnd = try container.decode(String.self, forKey: .dateEnd)

        previewImg = EventDTO.formatImageURL(previewImg)
    }

    /// ✅ `EventDTO`를 `Event`로 변환하는 메서드 추가
    func toEvent() -> Event {
        return Event(
            eventId: self.eventId,
            videoId: self.videoId ?? -1, // ✅ videoId가 없으면 기본값 -1
            eventLink: "",
            eventImage: self.previewImg,
            youtuberProfileImage: "",
            eventEndDate: self.dateEnd,
            eventTitle: self.eventItem,
            eventDescription: nil,
            isLiked: true // ✅ 좋아요한 이벤트이므로 기본적으로 true
        )
    }

    /// ✅ 이미지 URL을 절대 경로로 변환하는 함수
    private static func formatImageURL(_ url: String) -> String {
        if url.starts(with: "/") {
            return "https://pricedive-event.s3.ap-northeast-2.amazonaws.com" + url
        }
        return url
    }
}
