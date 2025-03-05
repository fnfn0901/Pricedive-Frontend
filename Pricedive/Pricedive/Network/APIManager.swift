//
//  APIManager.swift
//  Pricedive
//
//  Created by 신호연 on 2/12/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = URL(string: "http://localhost:8080")!

    private init() {}

    /// **공통 네트워크 요청 함수**
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL.absoluteString + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.other(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            print("📥 서버 응답 원본 데이터: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("❌ 디코딩 오류: \(error)")
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    /// **전체 이벤트 리스트 가져오기**
    func fetchEvents(completion: @escaping (Result<[EventDTO], NetworkError>) -> Void) {
        request(endpoint: "/events") { (result: Result<APIResponse<[EventDTO]>, NetworkError>) in
            switch result {
            case .success(let response):
                print("✅ [APIManager] 서버에서 받은 전체 데이터: \(response)")
                
                if response.data.isEmpty {
                    print("⚠️ [APIManager] 서버에서 받은 이벤트 리스트가 비어 있습니다.")
                }

                completion(.success(response.data))
                
            case .failure(let error):
                print("❌ [APIManager] 이벤트 가져오기 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    /// **특정 이벤트 상세 정보 가져오기**
    func fetchEventDetail(eventId: Int, completion: @escaping (Result<EventDTO, NetworkError>) -> Void) {
        request(endpoint: "/events/\(eventId)", completion: completion)
    }

    /// **좋아요한 이벤트 리스트 가져오기**
    func fetchLikedEvents(userId: Int, ongoing: Bool, completion: @escaping (Result<[LikedEventDTO], NetworkError>) -> Void) {
        let endpoint = "/like_events/user/\(userId)?ongoing=\(ongoing)"

        request(endpoint: endpoint) { (result: Result<[LikedEventDTO], NetworkError>) in
            switch result {
            case .success(let events):
                print("✅ 좋아요한 이벤트 데이터 정상 수신: \(events.count)개")
                completion(.success(events))
            case .failure(let error):
                print("❌ 좋아요한 이벤트 가져오기 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    /// **좋아요 추가 / 삭제 (`POST` → 추가, `DELETE` → 삭제)**
    func toggleLike(eventId: Int, isLiked: Bool, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let userId = 1
        let method = isLiked ? "DELETE" : "POST"
        let endpoint = "/like_events/user/\(userId)/event/\(eventId)"

        print("🔍 [API] 좋아요 요청 전송 - userId: \(userId), eventId: \(eventId), method: \(method), endpoint: \(endpoint)")

        request(endpoint: endpoint, method: method) { (result: Result<Data, NetworkError>) in
            switch result {
            case .success(let data):
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📥 서버 응답 원본 데이터: \(responseString)")
                    
                    if responseString.contains("이미 좋아요한 이벤트입니다.") {
                        print("⚠️ 서버 응답: 이미 좋아요한 상태이므로 상태 변경 안 함")
                        completion(.success(true))
                        return
                    }
                }
                completion(.success(!isLiked))

            case .failure(let error):
                if case .serverError(let statusCode) = error, statusCode == 400 {
                    print("⚠️ 서버에서 400 응답을 보냈지만, 좋아요 상태를 유지합니다.")
                    completion(.success(isLiked))
                } else {
                    print("❌ 좋아요 상태 변경 실패: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// **특정 비디오 상세 정보 가져오기**
    func fetchVideoDetail(videoId: Int, completion: @escaping (Result<VideoDTO, NetworkError>) -> Void) {
        let url = "/videos/\(videoId)"
        print("🔍 요청 URL: \(url)")
        request(endpoint: url) { (result: Result<APIResponse<VideoDTO>, NetworkError>) in
            switch result {
            case .success(let response):
                print("✅ 서버 응답 데이터: \(response)")
                completion(.success(response.data))
            case .failure(let error):
                print("❌ 서버 요청 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
}
