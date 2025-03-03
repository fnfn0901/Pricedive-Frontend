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

    init(from realmObject: ViewedProductRealm) {
        self.id = realmObject.id
        self.title = realmObject.title
        self.imageUrl = realmObject.imageUrl
        self.viewedDate = realmObject.viewedDate
        self.videoId = realmObject.videoId
    }

    func toRealmObject() -> ViewedProductRealm {
        return ViewedProductRealm(id: id, title: title, imageUrl: imageUrl, viewedDate: viewedDate, videoId: videoId)
    }

    /// `ViewedProduct` → `Event` 변환 메서드
    func toEvent() -> Event {
        return Event(
            eventId: id,
            videoId: videoId ?? -1,
            eventLink: "",
            eventImage: imageUrl,
            channelImg: "",
            eventEndDate: viewedDate,
            eventItem: title,
            eventDescription: ""
        )
    }
}
