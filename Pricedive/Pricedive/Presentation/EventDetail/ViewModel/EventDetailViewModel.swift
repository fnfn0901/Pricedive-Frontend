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
    @Published var gptComment: String?
    @Published var eventDescription: String = "이벤트 정보 없음"
    
    let userId: Int
    private let videoId: Int
    private let homeViewModel: HomeViewModel
    let event: Event
    private let gptService = GPTService()
    
    init(event: Event, homeViewModel: HomeViewModel) {
        self.videoId = event.videoId ?? -1
        self.userId = homeViewModel.userId
        self.homeViewModel = homeViewModel
        self.event = event
        self.isLiked = homeViewModel.isLiked(for: videoId)
        
        self.previewImg = event.eventImage
        
        self.eventDescription = event.eventDescription ?? "이벤트 정보 없음"
        
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
        
        APIManager.shared.fetchVideoDetail(videoId: videoId) { [weak self] (result: Result<VideoDTO, NetworkError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let video):
                    if video.id == -1 {
                        print("❌ 서버에서 올바른 비디오 데이터를 제공하지 않음")
                        return
                    }
                    self?.videoDetail = video
                    
                    if !video.description.isEmpty {
                        self?.eventDescription = video.description
                    }
                case .failure(let error):
                    print("❌ API 요청 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// **🔹 좋아요 상태 변경**
    func toggleLikeStatus(userId: Int, eventId: Int, completion: @escaping (Bool) -> Void) {
        
        let currentLikeStatus = isLiked
        let newLikeStatus = !currentLikeStatus
        self.isLiked = newLikeStatus
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        
        APIManager.shared.toggleLike(eventId: eventId, isLiked: currentLikeStatus) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let updatedIsLiked):
                    print("✅ 좋아요 상태 변경 성공: \(updatedIsLiked ? "❤️" : "🤍")")
                    self.isLiked = updatedIsLiked
                    completion(updatedIsLiked)

                case .failure(let error):
                    print("❌ 좋아요 상태 변경 실패: \(error.localizedDescription)")
                    self.isLiked = currentLikeStatus
                    completion(currentLikeStatus)
                }
                
                self.objectWillChange.send()
            }
        }
    }
    
    /// **🔹 GPT를 사용해 이벤트 댓글 자동 생성**
    func generateGPTComment() {
        print("📝 GPT 댓글 생성 요청: \(eventDescription)")

        guard let videoDetail = videoDetail else {
            print("❌ videoDetail이 없습니다.")
            return
        }

        let tags = videoDetail.tags
        let channelId = videoDetail.channelId

        gptService.generateComment(from: eventDescription, tags: tags, channelId: channelId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comment):
                    print("✅ GPT 댓글 생성 성공: \(comment)")
                    self?.gptComment = comment
                case .failure(let error):
                    print("❌ GPT 댓글 생성 실패: \(error.localizedDescription)")
                    self?.gptComment = "댓글을 생성할 수 없습니다. 다시 시도해주세요."
                }
            }
        }
    }
}
