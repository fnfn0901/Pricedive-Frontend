//
//  ViewedProduct.swift
//  Pricedive
//
//  Created by 신호연 on 12/26/24.
//

import Foundation

struct ViewedProduct {
    let id: Int
    let title: String
    let imageUrl: String
    let viewedDate: String
    let videoId: Int?

    func toEvent() -> Event {
        return Event(
            eventId: id,
            videoId: videoId ?? -1,
            eventLink: "",
            eventImage: imageUrl,
            youtuberProfileImage: "",
            eventEndDate: String(),
            eventTitle: title,
            eventDescription: "",
            isLiked: false
        )
    }
}
