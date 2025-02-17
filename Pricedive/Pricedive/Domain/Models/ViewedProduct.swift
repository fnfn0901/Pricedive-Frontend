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
    let viewedDate: Date
    let videoId: Int?

    func toEvent() -> Event {
        return Event(
            eventId: id,
            videoId: videoId ?? -1,
            eventLink: "",
            eventImage: imageUrl,
            youtuberProfileImage: "",
            eventEndDate: Date(),
            eventTitle: title,
            eventDescription: "",
            isLiked: false
        )
    }
}
