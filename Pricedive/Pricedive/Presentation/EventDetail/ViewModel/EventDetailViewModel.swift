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
    @Published var isLiked: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    @Published var previewImg: String? {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    @Published var gptComment: String?
    @Published var eventDescription: String = "이벤트 정보 없음"
    
    private var isRequestingLike = false
    
    let userId: Int
    private let videoId: Int
    private let homeViewModel: HomeViewModel
    let event: Event
    let gptService = GPTService()
    
    init(event: Event, homeViewModel: HomeViewModel) {
        self.videoId = event.videoId ?? -1
        self.userId = homeViewModel.userId
        self.homeViewModel = homeViewModel
        self.event = event
        self.isLiked = homeViewModel.isLiked(for: event.videoId ?? -1)
        self.previewImg = event.eventImage

        DispatchQueue.main.async {
            self.objectWillChange.send()
        }

        if videoId != -1 {
            fetchVideoDetail(videoId: videoId)
        }
    }
    
    /// **🔹 비디오 상세 정보 가져오기**
    func fetchVideoDetail(videoId: Int) {
        guard videoId != -1 else {
            print("❌ Error: 유효하지 않은 videoId (\(videoId)) - 요청 중단")
            return
        }

        APIManager.shared.fetchVideoDetail(videoId: videoId) { [weak self] (result: Result<VideoDTO, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let video):
                    self?.videoDetail = video

                    if !video.description.isEmpty {
                        self?.eventDescription = video.description
                    }

                    self?.previewImg = video.previewImg
                case .failure(let error):
                    print("❌ API 요청 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// **🔹 좋아요 상태 변경**
    func toggleLikeStatus(userId: Int, videoId: Int, completion: @escaping (Bool) -> Void) {
        guard !isRequestingLike else { return }
        isRequestingLike = true

        let previousState = isLiked
        let newLikeState = !previousState

        DispatchQueue.main.async {
            self.isLiked = newLikeState
        }

        APIManager.shared.toggleLike(videoId: videoId, isLiked: !previousState) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isRequestingLike = false

                switch result {
                case .success:
                    self.isLiked = newLikeState
                    self.homeViewModel.loadLikedEvents(ongoing: false)
                    completion(newLikeState)

                case .failure:
                    self.isLiked = previousState
                    completion(previousState)
                }
            }
        }
    }
    
    /// **🔹 GPT를 사용해 이벤트 댓글 자동 생성**
    func generateGPTComment() {
        guard let videoDetail = videoDetail else { return }

        gptService.generateComment(from: eventDescription, tags: videoDetail.tags, channelId: videoDetail.channelId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comment):
                    self?.gptComment = comment
                case .failure:
                    self?.gptComment = "댓글을 생성할 수 없습니다. 다시 시도해주세요."
                }
                self?.gptService.stopLoadingIndicator()
            }
        }
    }
    
    func loadLikedEvents() {
        homeViewModel.loadLikedEvents(ongoing: false)
        self.isLiked = homeViewModel.isLiked(for: event.videoId ?? -1)
        self.objectWillChange.send()
    }
}
