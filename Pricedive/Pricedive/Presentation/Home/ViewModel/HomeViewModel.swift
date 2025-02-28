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

    var userId: Int = 1
    private var cancellables = Set<AnyCancellable>()
    private var likedEvents = Set<Int>()

    init() {
        loadLikedEvents()
        loadEvents()
    }

    // ✅ 서버에서 좋아요한 이벤트 조회
    func loadLikedEvents() {
        APIManager.shared.fetchLikedEvents(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let likedEventIds):
                    self?.likedEvents = Set(likedEventIds)
                    self?.updateLikedEventsList()
                    print("✅ 좋아요한 이벤트 불러오기 성공: \(likedEventIds)")
                case .failure(let error):
                    print("❌ 좋아요한 이벤트 불러오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    // ✅ 전체 이벤트 리스트 조회
    func loadEvents() {
        APIManager.shared.fetchEvents { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventDTOs):
                    if eventDTOs.isEmpty {
                        print("⚠️ 이벤트 리스트가 비어 있습니다.")
                    }
                    let mappedEvents = eventDTOs.map { dto -> Event in
                        let videoId = dto.videoId
                        let eventEndDate = self?.parseDate(dto.dateEnd) ?? Date()
                        let isLiked = self?.likedEvents.contains(videoId) ?? false

                        return Event(
                            eventId: dto.eventId,
                            videoId: videoId,
                            eventLink: "",
                            eventImage: dto.previewImg,
                            youtuberProfileImage: "",
                            eventEndDate: eventEndDate,
                            eventTitle: dto.eventItem,
                            eventDescription: nil,
                            isLiked: isLiked
                        )
                    }

                    self?.events = mappedEvents
                    self?.updateLikedEventsList()
                    self?.objectWillChange.send()
                case .failure(let error):
                    print("❌ 이벤트 불러오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    // ✅ 좋아요 토글
    func toggleLike(for videoId: Int) {
        guard let event = events.first(where: { $0.videoId == videoId }) else {
            print("❌ 오류: videoId(\(videoId))에 해당하는 eventId를 찾을 수 없음")
            return
        }

        let eventId = event.eventId
        let isCurrentlyLiked = likedEvents.contains(videoId)

        APIManager.shared.toggleLike(userId: userId, eventId: eventId, isLiked: isCurrentlyLiked) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isLiked):
                    if isLiked {
                        self?.likedEvents.insert(videoId)
                    } else {
                        self?.likedEvents.remove(videoId)
                    }
                    self?.updateLikedEventsList()
                    self?.objectWillChange.send()
                    print("✅ 좋아요 상태 변경 성공: \(isLiked ? "❤️" : "🤍")")
                case .failure(let error):
                    print("❌ 좋아요 상태 변경 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    // ✅ 특정 비디오가 좋아요 되어있는지 확인
    func isLiked(for videoId: Int) -> Bool {
        return likedEvents.contains(videoId)
    }

    // ✅ 좋아요한 이벤트 리스트 업데이트
    private func updateLikedEventsList() {
        likedEventsList = events.filter { likedEvents.contains($0.videoId ?? -1) }
    }

    private func parseDate(_ dateString: String) -> Date {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]

        if let date = isoFormatter.date(from: dateString) {
            return date
        } else {
            print("⚠️ 날짜 변환 실패: \(dateString) → 기본값(Date()) 적용")
            return Date()
        }
    }
}
