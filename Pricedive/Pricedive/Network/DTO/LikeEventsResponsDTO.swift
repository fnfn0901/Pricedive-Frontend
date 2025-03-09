//
//  LikedEventsResponseDTO.swift
//  Pricedive
//
//  Created by 신호연 on 2/15/25.
//

import Foundation

/// 좋아요한 이벤트 ID 리스트 응답 DTO
struct LikedEventsResponseDTO: Decodable {
    let likedEventIds: [Int]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.likedEventIds = try container.decode([Int].self)
    }
}

struct LikedEventDTO: Decodable {
    let eventId: Int
    let eventItem: String
    var previewImg: String
    let dateEnd: String

    enum CodingKeys: String, CodingKey {
        case eventId
        case eventItem
        case previewImg
        case dateEnd
    }

    /// 기본 이미지 URL 설정
    private static let defaultImageURL = "https://pricedive-event.s3.ap-northeast-2.amazonaws.com/defaultimage.jpg"

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventId = try container.decode(Int.self, forKey: .eventId)
        eventItem = try container.decode(String.self, forKey: .eventItem)
        previewImg = try container.decodeIfPresent(String.self, forKey: .previewImg) ?? LikedEventDTO.defaultImageURL
        dateEnd = try container.decode(String.self, forKey: .dateEnd)

        previewImg = LikedEventDTO.formatImageURL(previewImg)
    }

    /// `LikedEventDTO` → `Event` 변환 메서드
    func toEvent() -> Event {
        return Event(
            eventId: eventId,
            videoId: nil,
            eventLink: "",
            eventImage: previewImg,
            channelImg: "",
            eventEndDate: dateEnd,
            eventItem: eventItem,
            eventDescription: nil
        )
    }
    
    /// 이미지 URL을 절대 경로로 변환하는 함수
    private static func formatImageURL(_ url: String) -> String {
        if url.starts(with: "/") {
            return "https://pricedive-event.s3.ap-northeast-2.amazonaws.com" + url
        }
        return url
    }
}
