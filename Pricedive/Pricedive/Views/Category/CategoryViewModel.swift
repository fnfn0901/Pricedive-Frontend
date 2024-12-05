//
//  CategoryViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 12/6/24.
//

import Foundation
import Combine

class CategoryViewModel: ObservableObject {
    @Published var categories: [Category] = []
    
    init() {
        loadCategories()
    }
    
    private func loadCategories() {
        categories = [
            Category(name: "의류&잡화"),
            Category(name: "전자기기"),
            Category(name: "홈&리빙"),
            Category(name: "식품"),
            Category(name: "뷰티&케어"),
            Category(name: "유아&아동"),
            Category(name: "스포츠&아웃도어"),
            Category(name: "취미&엔터"),
            Category(name: "자동차&공구"),
            Category(name: "반려동물"),
            Category(name: "헬스&건강")
        ]
    }
}
