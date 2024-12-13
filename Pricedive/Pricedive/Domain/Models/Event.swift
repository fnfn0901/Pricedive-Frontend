//
//  Event.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import Foundation

struct Event: Codable {
    let eventId: Int               // 이벤트 고유 ID
    let eventImage: String         // 이벤트 이미지
    let youtuberProfileImage: String // 유튜버 프로필 이미지 URL
    let eventEndDate: Date         // 이벤트 종료일
    let eventTitle: String         // 이벤트 제목
    let eventDescription: String?  // 이벤트 상세 설명
    var isLiked: Bool?             // 좋아요 여부
}
