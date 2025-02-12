//
//  EventDetailViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import Foundation
import Combine

class EventDetailViewModel: ObservableObject {
    @Published var eventDetail: EventDTO?
    private let eventId: Int
    private let homeViewModel: HomeViewModel

    init(eventId: Int, homeViewModel: HomeViewModel) {
        self.eventId = eventId
        self.homeViewModel = homeViewModel
    }

    /// 이벤트 상세 정보 API 호출
    func fetchEventDetail() {
        APIManager.shared.fetchEventDetail(eventId: eventId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let event):
                    self?.eventDetail = event
                case .failure(let error):
                    print("❌ 이벤트 상세 정보 불러오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    /// 좋아요 상태 변경
    func toggleLikeStatus() {
        homeViewModel.toggleLike(for: eventId)
    }

    var isLiked: Bool {
        return homeViewModel.isLiked(for: eventId)
    }
}
