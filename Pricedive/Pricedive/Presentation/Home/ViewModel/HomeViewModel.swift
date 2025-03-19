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
    @Published var likedEventsList: [EventDTO] = []
    let categoryViewModel = CategoryViewModel()
    
    @Published var selectedCategory: String? = nil
    @Published var searchQuery: String = ""
    
    var userId: Int = 1
    private var cancellables = Set<AnyCancellable>()
    private var likedEvents = Set<Int>()
    
    init() {
        loadLikedEvents(ongoing: false)
        loadEvents()
    }
    
    // ✅ 좋아요한 이벤트 리스트 업데이트
    private func updateLikedEventsList() {
        likedEventsList = likedEventsList.filter { likedEvents.contains($0.eventId) }
    }
    
    // ✅ 좋아요한 이벤트 조회
    private var isLoadingLikedEvents = false

    func loadLikedEvents(ongoing: Bool) {
        guard !isLoadingLikedEvents else { return }
        isLoadingLikedEvents = true
        
        APIManager.shared.fetchLikedEvents(userId: userId, ongoing: ongoing) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingLikedEvents = false
                switch result {
                case .success(let likedEventsDTOs):
                    self.likedEvents = Set(likedEventsDTOs.map { $0.videoId })
                    
                    // ✅ 먼저 리스트 생성
                    let eventDTOs = likedEventsDTOs.map { dto in
                        EventDTO(
                            eventId: -1,
                            category: "기본 카테고리",
                            eventNums: 0,
                            eventItem: dto.eventItem,
                            previewImg: dto.previewImg,
                            videoId: dto.videoId,
                            dateEnd: dto.dateEnd ?? "",
                            channelImg: ""
                        )
                    }
                    
                    // ✅ 이벤트 마감일 기준으로 정렬 (많이 남은 순 → 내림차순)
                    self.likedEventsList = eventDTOs.sorted { dto1, dto2 in
                        guard
                            let date1 = self.parseDate(dto1.dateEnd ?? ""),
                            let date2 = self.parseDate(dto2.dateEnd ?? "")
                        else {
                            return false
                        }
                        return date1 > date2 // 내림차순
                    }
                    
                case .failure(let error):
                    print("❌ 좋아요한 이벤트 불러오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // ✅ 좋아요 토글
    func toggleLike(for eventId: Int, completion: @escaping (Bool) -> Void) {
        let isCurrentlyLiked = likedEvents.contains(eventId)

        APIManager.shared.toggleLike(videoId: eventId, isLiked: !isCurrentlyLiked) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    print("✅ 좋아요 상태 변경 성공: \(isCurrentlyLiked ? "❤️ → 🤍" : "🤍 → ❤️")")
                    
                    if isCurrentlyLiked {
                        self.likedEvents.remove(eventId)
                        self.likedEventsList.removeAll { $0.eventId == eventId }
                    } else {
                        self.likedEvents.insert(eventId)
                    }
                    
                    self.objectWillChange.send()
                    completion(!isCurrentlyLiked)
                    
                case .failure(let error):
                    print("❌ 좋아요 상태 변경 실패: \(error.localizedDescription)")
                    
                    self.objectWillChange.send()
                    completion(isCurrentlyLiked)
                }
            }
        }
    }
    
    // ✅ 전체 이벤트 리스트 조회
    func loadEvents() {
        var endpoint = "/events"

        var queryParams: [String] = []
        if let category = selectedCategory {
            queryParams.append("category=\(category)")
        }
        if !searchQuery.isEmpty {
            queryParams.append("search=\(searchQuery)")
        }

        if !queryParams.isEmpty {
            endpoint += "?" + queryParams.joined(separator: "&")
        }

        APIManager.shared.fetchEvents(endpoint: endpoint) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let eventDTOs):
                    if eventDTOs.isEmpty {
                        print("⚠️ [ViewModel] 검색 결과가 없습니다.")
                    }
                    let mappedEvents = eventDTOs.compactMap { dto -> Event? in
                        guard !dto.eventItem.isEmpty, !dto.previewImg.isEmpty, !(dto.dateEnd?.isEmpty ?? true) else {
                            print("⚠️ 필수 값 누락으로 변환 실패: \(dto)")
                            return nil
                        }
                        return Event(
                            eventId: dto.eventId,
                            videoId: dto.videoId,
                            eventLink: "",
                            eventImage: dto.previewImg,
                            channelImg: dto.channelImg,
                            eventEndDate: dto.dateEnd ?? "",
                            eventItem: dto.eventItem,
                            eventDescription: nil
                        )
                    }
                    self?.events = mappedEvents
                    self?.objectWillChange.send()
                    
                case .failure(let error):
                    print("❌ 이벤트 불러오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // ✅ 특정 비디오가 좋아요 되어있는지 확인
    func isLiked(for eventId: Int) -> Bool {
        return likedEvents.contains(eventId)
    }
    
    func parseDate(_ dateString: String) -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        if let date = isoFormatter.date(from: dateString) {
            return date
        } else {
            print("⚠️ 날짜 변환 실패: \(dateString)")
            return nil
        }
    }

    /// ✅ 검색 기능
    func searchEvents(category: String?, query: String) {
        self.selectedCategory = category
        self.searchQuery = query
        loadEvents()
    }
    /// ✅ 검색 & 필터 초기화
    func resetFilters() {
        self.selectedCategory = nil
        self.searchQuery = ""
        loadEvents()
    }
}
