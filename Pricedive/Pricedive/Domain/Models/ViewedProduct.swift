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

    /// ✅ 기본 생성자 추가
    init(id: Int, title: String, imageUrl: String, viewedDate: String, videoId: Int?) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.viewedDate = viewedDate
        self.videoId = videoId
    }

    /// ✅ Realm 객체에서 변환할 때 올바르게 초기화
    init(from realmObject: ViewedProductRealm) {
        self.id = realmObject.id
        self.title = realmObject.title
        self.imageUrl = realmObject.imageUrl
        self.viewedDate = realmObject.viewedDate
        self.videoId = realmObject.videoId
    }

    /// ✅ Realm 객체로 변환 시 올바르게 생성자 호출
    func toRealmObject() -> ViewedProductRealm {
        let realmObject = ViewedProductRealm()
        realmObject.id = id
        realmObject.title = title
        realmObject.imageUrl = imageUrl
        realmObject.viewedDate = viewedDate
        realmObject.videoId = videoId
        return realmObject
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
