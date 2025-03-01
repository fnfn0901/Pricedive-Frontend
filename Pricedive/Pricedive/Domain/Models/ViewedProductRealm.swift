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
    @Persisted var videoId: Int?

    convenience init(id: Int, title: String, imageUrl: String, viewedDate: String, videoId: Int?) {
        self.init()
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.viewedDate = viewedDate
        self.videoId = videoId
    }
}
