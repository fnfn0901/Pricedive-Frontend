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
    let dateEnd: String?
    let channelImg: String
    
    enum CodingKeys: String, CodingKey {
        case eventId, category, eventNums, eventItem, previewImg, videoId, dateEnd, channelImg
    }
    
    init(eventId: Int, category: String, eventNums: Int, eventItem: String, previewImg: String, videoId: Int?, dateEnd: String, channelImg: String) {
        self.eventId = eventId
        self.category = category
        self.eventNums = eventNums
        self.eventItem = eventItem
        self.previewImg = EventDTO.formatImageURL(previewImg)
        self.videoId = videoId
        self.dateEnd = dateEnd
        self.channelImg = channelImg
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventId = try container.decode(Int.self, forKey: .eventId)
        category = try container.decode(String.self, forKey: .category)
        eventNums = try container.decode(Int.self, forKey: .eventNums)
        eventItem = try container.decode(String.self, forKey: .eventItem)
        previewImg = try container.decode(String.self, forKey: .previewImg)
        videoId = try container.decodeIfPresent(Int.self, forKey: .videoId)
        dateEnd = try container.decodeIfPresent(String.self, forKey: .dateEnd)
        channelImg = try container.decode(String.self, forKey: .channelImg)
        
        previewImg = previewImg.isEmpty ? "" : EventDTO.formatImageURL(previewImg)
    }
    
    /// ✅ `EventDTO`를 `Event`로 변환하는 메서드
    func toEvent() -> Event {
        return Event(
            eventId: self.eventId,
            videoId: self.videoId ?? -1,
            eventLink: "",
            eventImage: self.previewImg,
            channelImg: self.channelImg,
            eventEndDate: self.dateEnd ?? "",
            eventItem: self.eventItem,
            eventDescription: nil
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
