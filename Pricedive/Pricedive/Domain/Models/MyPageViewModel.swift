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
            guard let viewedDate = MyPageViewModel.dateFormatter.date(from: product.viewedDate) else { return }
            
            if calendar.isDate(viewedDate, inSameDayAs: today) {
                todayProducts.append(product)
            } else if calendar.isDate(viewedDate, inSameDayAs: yesterday) {
                yesterdayProducts.append(product)
            } else if viewedDate >= startOfWeek {
                thisWeekProducts.append(product)
            }
        }
        
        return [
            ("오늘", todayProducts),
            ("어제", yesterdayProducts),
            ("이번 주", thisWeekProducts)
        ].filter { !$0.1.isEmpty }
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }()
}
