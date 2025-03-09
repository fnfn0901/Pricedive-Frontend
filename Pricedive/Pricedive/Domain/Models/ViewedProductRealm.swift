//
//  ViewedProductRealm.swift
//  Pricedive
//
//  Created by 신호연 on 3/1/25.
//

import Foundation
import RealmSwift

class ViewedProductRealm: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var imageUrl: String
    @Persisted var viewedDate: String
    @Persisted var eventEndDate: String
    @Persisted var videoId: Int?

    /// ✅ Realm 객체를 수동으로 초기화하도록 수정
    convenience init(id: Int, title: String, imageUrl: String, viewedDate: String, eventEndDate: String, videoId: Int?) {
        self.init()
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.viewedDate = viewedDate
        self.eventEndDate = eventEndDate
        self.videoId = videoId
    }
}
