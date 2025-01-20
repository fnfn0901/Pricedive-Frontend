//
//  MyPageViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 1/20/25.
//

import Foundation
import Combine

class MyPageViewModel: ObservableObject {
    @Published var groupedProducts: [(String, [ViewedProduct])] = []

    init() {
        fetchViewedProducts()
    }

    func fetchViewedProducts() {
        // 목데이터
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let earlierThisWeek = calendar.date(byAdding: .day, value: -3, to: today)!

        let sampleData = [
            ViewedProduct(id: 1, title: "오늘 본 상품 1", imageUrl: "https://via.placeholder.com/150", viewedDate: today),
            ViewedProduct(id: 2, title: "오늘 본 상품 2", imageUrl: "https://via.placeholder.com/150", viewedDate: today),
            ViewedProduct(id: 3, title: "어제 본 상품 1", imageUrl: "https://via.placeholder.com/150", viewedDate: yesterday),
            ViewedProduct(id: 4, title: "이번 주 본 상품 1", imageUrl: "https://via.placeholder.com/150", viewedDate: earlierThisWeek)
        ]

        groupedProducts = groupProductsByDate(sampleData)
    }

    private func groupProductsByDate(_ products: [ViewedProduct]) -> [(String, [ViewedProduct])] {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        var todayProducts = [ViewedProduct]()
        var yesterdayProducts = [ViewedProduct]()
        var thisWeekProducts = [ViewedProduct]()

        products.forEach { product in
            if calendar.isDate(product.viewedDate, inSameDayAs: today) {
                todayProducts.append(product)
            } else if calendar.isDate(product.viewedDate, inSameDayAs: yesterday) {
                yesterdayProducts.append(product)
            } else if product.viewedDate >= startOfWeek {
                thisWeekProducts.append(product)
            }
        }

        return [
            ("오늘", todayProducts),
            ("어제", yesterdayProducts),
            ("이번 주", thisWeekProducts)
        ].filter { !$0.1.isEmpty }
    }
}
