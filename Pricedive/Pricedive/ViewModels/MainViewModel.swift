//
//  MainViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 11/22/24.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    @Published var categories: [Category] = [] // 카테고리 리스트
    @Published var events: [Event] = []       // 이벤트 리스트

    private var cancellables = Set<AnyCancellable>()


}
