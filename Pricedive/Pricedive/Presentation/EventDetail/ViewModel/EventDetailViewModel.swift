//
//  EventDetailViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 12/14/24.
//

import Foundation
import Combine

class EventDetailViewModel: ObservableObject {
    @Published var videoDetail: VideoDTO?
    @Published var isLiked: Bool = false
    @Published var previewImg: String?

    let userId: Int
    private let videoId: Int
    private let homeViewModel: HomeViewModel
    let event: Event

    init(event: Event, homeViewModel: HomeViewModel) {
        self.videoId = event.videoId ?? -1
        self.userId = homeViewModel.userId
        self.homeViewModel = homeViewModel
        self.event = event
        self.isLiked = homeViewModel.isLiked(for: videoId)

        self.previewImg = event.eventImage
        print("✅ EventDetailViewModel 초기화 - videoId: \(videoId), previewImg: \(String(describing: previewImg))")

        if videoId != -1 {
            fetchVideoDetail(videoId: videoId)
        } else {
            print("❌ Error: 유효하지 않은 videoId (\(videoId)) - 비디오 상세 요청 안 함")
        }
    }

    /// **🔹 비디오 상세 정보 가져오기**
    func fetchVideoDetail(videoId: Int) {
        guard videoId != -1 else {
            print("❌ Error: 유효하지 않은 videoId (\(videoId)) - 요청 중단")
            return
        }
        
        print("✅ API 요청 전 videoId: \(videoId)")
        APIManager.shared.fetchVideoDetail(videoId: videoId) { [weak self] (result: Result<VideoDTO, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let video):
                    print("✅ 서버 응답 videoId: \(video.id)")
                    if video.id == -1 {
                        print("❌ 서버에서 올바른 비디오 데이터를 제공하지 않음")
                        return
                    }
                    self?.videoDetail = video
                case .failure(let error):
                    print("❌ API 요청 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    /// **🔹 좋아요 상태 변경**
    func toggleLikeStatus(userId: Int, eventId: Int, completion: @escaping (Bool) -> Void) {
        print("✅ 좋아요 요청 - userId: \(userId), eventId: \(eventId), 현재 상태: \(isLiked)")

        let method = isLiked ? "DELETE" : "POST"
        APIManager.shared.toggleLike(userId: userId, eventId: eventId, isLiked: isLiked) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isLiked):
                    print("✅ 좋아요 상태 변경 성공: \(isLiked ? "❤️" : "🤍")")
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
