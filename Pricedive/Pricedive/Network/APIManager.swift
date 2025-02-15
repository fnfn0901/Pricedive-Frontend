//
//  APIManager.swift
//  Pricedive
//
//  Created by 신호연 on 2/12/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = URL(string: "http://172.30.1.71:8080")!

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

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }

    /// **전체 이벤트 리스트 가져오기**
    func fetchEvents(completion: @escaping (Result<[EventDTO], NetworkError>) -> Void) {
        request(endpoint: "/events", completion: completion)
    }

    /// **특정 이벤트 상세 정보 가져오기**
    func fetchEventDetail(eventId: Int, completion: @escaping (Result<EventDTO, NetworkError>) -> Void) {
        request(endpoint: "/events/\(eventId)", completion: completion)
    }

    /// **특정 유저가 좋아요한 이벤트 리스트 가져오기**
    func fetchLikedEvents(userId: Int, completion: @escaping (Result<[Int], NetworkError>) -> Void) {
        request(endpoint: "/like_events/user/\(userId)", completion: completion)
    }

    /// **좋아요 추가 / 삭제 (`POST` → 추가, `DELETE` → 삭제)**
    func toggleLike(userId: Int, eventId: Int, isLiked: Bool, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let method = isLiked ? "DELETE" : "POST"
        request(endpoint: "/like_events/user/\(userId)/event/\(eventId)", method: method, completion: completion)
    }
    
    /// **특정 비디오 상세 정보 가져오기**
    func fetchVideoDetail(videoId: Int, completion: @escaping (Result<VideoDTO, NetworkError>) -> Void) {
        request(endpoint: "/videos/\(videoId)", completion: completion)
    }
}
