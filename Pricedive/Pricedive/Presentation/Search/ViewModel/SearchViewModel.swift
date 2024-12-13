//
//  SearchViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 12/6/24.
//

import Combine
import Foundation

class SearchViewModel {
    // MARK: - Input
    @Published var searchQuery: String = ""

    // MARK: - Output
    let filteredEvents = CurrentValueSubject<[Event], Never>([])

    // MARK: - Sample Data
    private let events: [Event] = (0..<10).map { _ in
        Event(
            eventId: Int.random(in: 1...1000),
            eventImage: "https://m-goods.sivillage.com/goods/getGoodDescCont.siv?goods_no=2303705383/proxy/src/http://www.bioderma.co.kr/img/detail/Ato_UCR_img3.jpg/dims/optimize",
            youtuberProfileImage: "https://yt3.googleusercontent.com/Oh7Fb_JBhkVUB1y0671PeYNSYJbxouMd6DEQzcN9JHaVDgp5b4DlKfRt0ehW53Ol7UxMD0xkJts=s900-c-k-c0x00ffffff-no-rj",
            eventEndDate: Date(),
            eventTitle: "아토덤 인텐시브밤 200ml + 울트라 크림 추가 증정",
            eventDescription: "설명설명",
            isLiked: false
        )
    }
    
    var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
    }

    private func setupBindings() {
        $searchQuery
            .map { [weak self] query in
                guard let self = self else { return [] }
                return self.events.filter { query.isEmpty || $0.eventTitle.contains(query) }
            }
            .sink { [weak self] filtered in
                self?.filteredEvents.value = filtered
            }
            .store(in: &cancellables)
    }
}
