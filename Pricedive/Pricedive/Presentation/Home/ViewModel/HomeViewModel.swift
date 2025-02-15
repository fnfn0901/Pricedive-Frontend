//
//  HomeViewModel.swift
//  Pricedive
//
//  Created by 신호연 on 2/12/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var likedEventsList: [Event] = []
    
    var userId: Int
    private var cancellables = Set<AnyCancellable>()
    private var likedEvents = Set<Int>()

    init(userId: Int) {
        self.userId = userId
    }

    // API에서 이벤트 목록을 가져오는 메서드
    func loadEvents() {
        APIManager.shared.fetchEvents { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventDTOs):
                    self?.events = eventDTOs.map { dto in
                        Event(
                            eventId: dto.eventId,
                            eventLink: "",
                            eventImage: dto.previewImg,
                            youtuberProfileImage: "",
                            eventEndDate: Date(),
                            eventTitle: dto.eventItem,
                            eventDescription: nil,
                            isLiked: self?.likedEvents.contains(dto.eventId) ?? false
                        )
                    }
                    self?.updateLikedEventsList()
                case .failure(let error):
                    print("Error fetching events: \(error.localizedDescription)")
                }
            }
        }
    }

    // 좋아요 상태 토글 메서드
    func toggleLike(for eventId: Int) {
        if likedEvents.contains(eventId) {
            likedEvents.remove(eventId)
        } else {
            likedEvents.insert(eventId)
        }
        updateLikeStatus(for: eventId)
        updateLikedEventsList()
    }

    // 특정 이벤트가 좋아요 되어있는지 확인
    func isLiked(for eventId: Int) -> Bool {
        return likedEvents.contains(eventId)
    }

    // 좋아요한 리스트 업데이트
    private func updateLikedEventsList() {
        likedEventsList = events.filter { likedEvents.contains($0.eventId) }
    }

    // 좋아요 상태 변경 시 UI 업데이트
    private func updateLikeStatus(for eventId: Int) {
        if let index = events.firstIndex(where: { $0.eventId == eventId }) {
            events[index].isLiked = likedEvents.contains(eventId)
            objectWillChange.send()
        }
    }

    // 좋아요 상태 변경 API 요청
    func toggleLikeStatus(userId: Int, eventId: Int, completion: @escaping (Bool) -> Void) {
        let isCurrentlyLiked = likedEvents.contains(eventId)
        
        APIManager.shared.toggleLike(userId: userId, eventId: eventId, isLiked: isCurrentlyLiked) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isLiked):
                    if isLiked {
                        self.likedEvents.insert(eventId)
                    } else {
                        self.likedEvents.remove(eventId)
                    }
                    self.updateLikedEventsList()
                    completion(isLiked)
                case .failure(let error):
                    print("❌ 좋아요 상태 변경 실패: \(error.localizedDescription)")
                    completion(self.likedEvents.contains(eventId))
                }
            }
        }
    }
}
