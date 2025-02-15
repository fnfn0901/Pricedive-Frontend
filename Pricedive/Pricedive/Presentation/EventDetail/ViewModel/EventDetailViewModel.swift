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
    @Published var isLiked: Bool = false

    let userId: Int
    private let eventId: Int
    private let homeViewModel: HomeViewModel

    init(eventId: Int, homeViewModel: HomeViewModel) {
        self.eventId = eventId
        self.userId = homeViewModel.userId
        self.homeViewModel = homeViewModel
        self.isLiked = homeViewModel.isLiked(for: eventId)
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
    func toggleLikeStatus(userId: Int, eventId: Int, completion: @escaping (Bool) -> Void) {
        let isCurrentlyLiked = isLiked

        APIManager.shared.toggleLike(userId: userId, eventId: eventId, isLiked: isCurrentlyLiked) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isLiked):
                    self.isLiked = isLiked
                    completion(isLiked)
                case .failure(let error):
                    print("❌ 좋아요 상태 변경 실패: \(error.localizedDescription)")
                    completion(self.isLiked)
                }
            }
        }
    }
}
