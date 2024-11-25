//
//  ProductDetailViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import Foundation

final class ProductDetailViewModel: ObservableObject {
    @Published var event: Event   // 상세 이벤트 정보

    init(event: Event) {
        self.event = event
    }

    func toggleSaved() {
        event.isLiked?.toggle()
    }
}
