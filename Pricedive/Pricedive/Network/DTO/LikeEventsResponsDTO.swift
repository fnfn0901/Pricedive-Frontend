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
