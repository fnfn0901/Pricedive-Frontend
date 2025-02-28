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
    let videoId: Int
    let dateEnd: String

    enum CodingKeys: String, CodingKey {
        case eventId
        case category
        case eventNums
        case eventItem
        case previewImg
        case videoId
        case dateEnd
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        eventId = try container.decode(Int.self, forKey: .eventId)
        category = try container.decode(String.self, forKey: .category)
        eventNums = try container.decode(Int.self, forKey: .eventNums)
        eventItem = try container.decode(String.self, forKey: .eventItem)
        previewImg = try container.decode(String.self, forKey: .previewImg)
        videoId = try container.decode(Int.self, forKey: .videoId)
        dateEnd = try container.decode(String.self, forKey: .dateEnd)

        if previewImg.starts(with: "/") {
            previewImg = "https://pricedive-event.s3.ap-northeast-2.amazonaws.com" + previewImg
        }
    }
}
