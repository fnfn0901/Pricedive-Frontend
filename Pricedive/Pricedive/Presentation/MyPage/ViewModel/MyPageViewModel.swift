//
//  MyPageViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 12/26/24.
//

import Foundation
import Combine
import RealmSwift

class MyPageViewModel: ObservableObject {
    @Published var groupedProducts: [(String, [ViewedProduct])] = []

    let homeViewModel: HomeViewModel
    private let repository = ViewedProductRepository()

    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        loadViewedProducts()
    }
    
    func loadViewedProducts() {
        let products = repository.getViewedProducts()
        groupedProducts = groupProductsByDate(products)
    }

    func clearAllViewedProducts() {
        repository.clearAllViewedProducts()
        groupedProducts = []
    }
    
    func deleteViewedProduct(_ product: ViewedProduct) {
        repository.deleteViewedProduct(product)
        loadViewedProducts()
    }

    private func groupProductsByDate(_ products: [ViewedProduct]) -> [(String, [ViewedProduct])] {
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        var todayProducts = [ViewedProduct]()
        var yesterdayProducts = [ViewedProduct]()
        var thisWeekProducts = [ViewedProduct]()

        let dateFormatter = ISO8601DateFormatter()

        products.forEach { product in
            guard let eventDate = dateFormatter.date(from: product.viewedDate) else { return }

            if calendar.isDate(eventDate, inSameDayAs: today) {
                todayProducts.append(product)
            } else if calendar.isDate(eventDate, inSameDayAs: yesterday) {
                yesterdayProducts.append(product)
            } else if eventDate >= startOfWeek {
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
