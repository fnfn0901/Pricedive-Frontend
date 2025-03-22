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
    let eventEndDate: String
    let videoId: Int

    init(id: Int, title: String, imageUrl: String, viewedDate: String, eventEndDate: String, videoId: Int) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.viewedDate = viewedDate
        self.eventEndDate = eventEndDate
        self.videoId = videoId
    }

    init(from realmObject: ViewedProductRealm) {
        self.id = realmObject.id
        self.title = realmObject.title
        self.imageUrl = realmObject.imageUrl
        self.viewedDate = realmObject.viewedDate
        self.eventEndDate = realmObject.eventEndDate
        self.videoId = realmObject.videoId
    }

    func toRealmObject() -> ViewedProductRealm {
        ViewedProductRealm(
            id: id,
            title: title,
            imageUrl: imageUrl,
            viewedDate: viewedDate,
            eventEndDate: eventEndDate,
            videoId: videoId
        )
    }

    func toEvent() -> Event {
        Event(
            eventId: id,
            videoId: videoId,
            eventLink: "",
            eventImage: imageUrl,
            channelImg: "",
            eventEndDate: eventEndDate,
            eventItem: title,
            eventDescription: ""
        )
    }
}
