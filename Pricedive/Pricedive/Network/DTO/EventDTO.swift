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
    let video: VideoDTO?

    enum CodingKeys: String, CodingKey {
        case eventId
        case category
        case eventNums
        case eventItem
        case previewImg
        case video
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        eventId = try container.decodeIfPresent(Int.self, forKey: .eventId) ?? -1
        category = try container.decodeIfPresent(String.self, forKey: .category) ?? "기타"
        eventNums = try container.decodeIfPresent(Int.self, forKey: .eventNums) ?? 0
        eventItem = try container.decodeIfPresent(String.self, forKey: .eventItem) ?? "이벤트 상품 정보 없음"
        previewImg = try container.decodeIfPresent(String.self, forKey: .previewImg) ?? ""

        video = try container.decodeIfPresent(VideoDTO.self, forKey: .video)

        if previewImg.starts(with: "/") {
            previewImg = "https://pricedive-event.s3.ap-northeast-2.amazonaws.com" + previewImg
        }
    }
}
