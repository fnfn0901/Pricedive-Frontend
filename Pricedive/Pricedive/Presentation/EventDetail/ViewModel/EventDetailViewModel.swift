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
    @Published var videoDetail: VideoDTO?

    private let eventId: Int
    private let homeViewModel: HomeViewModel

    init(eventId: Int, homeViewModel: HomeViewModel) {
        self.eventId = eventId
        self.homeViewModel = homeViewModel
    }

    /// 비디오 상세 정보 API 호출
    func fetchVideoDetail(videoId: Int) {
        APIManager.shared.fetchVideoDetail(videoId: videoId) { [weak self] (result: Result<VideoDTO, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let video):
                    self?.videoDetail = video
                case .failure(let error):
                    print("❌ 비디오 상세 정보 불러오기 실패: \(error.localizedDescription)")
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
