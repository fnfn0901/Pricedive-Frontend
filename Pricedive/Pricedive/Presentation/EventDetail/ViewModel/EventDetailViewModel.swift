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
    private let event: Event

    init(event: Event, homeViewModel: HomeViewModel) {
        self.videoId = event.videoId ?? -1
        self.userId = homeViewModel.userId
        self.homeViewModel = homeViewModel
        self.event = event
        self.isLiked = homeViewModel.isLiked(for: videoId)

        self.previewImg = event.eventImage

        print("✅ EventDetailViewModel 초기화 - videoId: \(videoId), previewImg: \(String(describing: previewImg))")
        fetchVideoDetail(videoId: videoId)
    }

    /// **🔹 비디오 상세 정보 가져오기**
    func fetchVideoDetail(videoId: Int) {
        APIManager.shared.fetchVideoDetail(videoId: videoId) { [weak self] (result: Result<VideoDTO, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let video):
                    if video.id == -1 {
                        print("❌ 서버에서 유효한 비디오 정보를 제공하지 않음")
                        return
                    }

                    let newPreviewImg = video.previewImg ?? self?.previewImg
                    if self?.previewImg != newPreviewImg {
                        print("🔄 previewImg 변경됨: \(String(describing: newPreviewImg))")
                    }

                    self?.previewImg = newPreviewImg
                    self?.videoDetail = video
                    print("✅ 비디오 상세 정보 가져오기 성공: \(video), 최종 previewImg: \(String(describing: self?.previewImg))")
                case .failure(let error):
                    print("❌ 비디오 상세 정보 불러오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    /// **🔹 좋아요 상태 변경**
    func toggleLikeStatus(userId: Int, videoId: Int, completion: @escaping (Bool) -> Void) {
        let isCurrentlyLiked = isLiked

        APIManager.shared.toggleLike(userId: userId, videoId: videoId, isLiked: isCurrentlyLiked) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isLiked):
                    self.isLiked = isLiked
                    print("✅ 좋아요 상태 변경 성공: \(isLiked ? "❤️" : "🤍")")
                    completion(isLiked)
                case .failure(let error):
                    print("❌ 좋아요 상태 변경 실패: \(error.localizedDescription)")
                    completion(self.isLiked)
                }
            }
        }
    }
}
