//
//  SearchViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 11/25/24.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var query: String = ""         // 검색어
    @Published var searchResults: [Event] = [] // 검색된 이벤트 리스트

    private var cancellables = Set<AnyCancellable>()

    init(events: [Event]) {
        $query
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { query in
                events.filter { event in
                    event.eventTitle.contains(query)
                }
            }
            .assign(to: &$searchResults)
    }
}
