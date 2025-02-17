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
                        let videoId = dto.video?.id ?? -1
                        let isLiked = self?.likedEvents.contains(videoId) ?? false

                        return Event(
                            eventId: dto.eventId,
                            videoId: videoId,
                            eventLink: dto.video?.urlLink ?? "",
                            eventImage: dto.previewImg,
                            youtuberProfileImage: dto.video?.channelImg ?? "",
                            eventEndDate: self?.parseDate(dto.video?.dateEnd) ?? Date(),
                            eventTitle: dto.video?.title ?? dto.eventItem,
                            eventDescription: dto.video?.description,
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
        let isCurrentlyLiked = likedEvents.contains(videoId)

        APIManager.shared.toggleLike(userId: userId, videoId: videoId, isLiked: isCurrentlyLiked) { [weak self] result in
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

    private func parseDate(_ dateString: String?) -> Date {
        guard let dateString = dateString, !dateString.isEmpty else {
            print("⚠️ 날짜 변환 실패: 입력된 날짜 문자열이 없음 → 기본값(Date()) 적용")
            return Date()
        }

        if dateString == "0000-00-00 00:00:00" {
            print("⚠️ 날짜 변환 실패: 서버에서 제공한 기본값 ('0000-00-00 00:00:00') 감지 → Date.distantFuture 설정")
            return Date.distantFuture
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        if let date = formatter.date(from: dateString) {
            return date
        } else {
            print("⚠️ 날짜 변환 실패: \(dateString) → 기본값(Date()) 적용")
            return Date()
        }
    }
}
