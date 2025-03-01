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

    /// ✅ **`Event`로 변환하는 메서드 추가**
    func toEvent() -> Event {
        return Event(
            eventId: id,
            videoId: videoId ?? -1,
            eventLink: "",
            eventImage: imageUrl,
            youtuberProfileImage: "",
            eventEndDate: viewedDate,
            eventTitle: title,
            eventDescription: "",
            isLiked: false
        )
    }
}
