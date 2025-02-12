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
    private var cancellables = Set<AnyCancellable>()

    // 좋아요한 이벤트를 저장하는 Set
    private var likedEvents = Set<Int>()

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
    }

    // 특정 이벤트가 좋아요 되어있는지 확인
    func isLiked(for eventId: Int) -> Bool {
        return likedEvents.contains(eventId)
    }

    // 좋아요 상태 변경 시 UI 업데이트
    private func updateLikeStatus(for eventId: Int) {
        if let index = events.firstIndex(where: { $0.eventId == eventId }) {
            events[index].isLiked = likedEvents.contains(eventId)
            objectWillChange.send() // UI 업데이트 반영
        }
    }
}
