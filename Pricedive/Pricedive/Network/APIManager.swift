//
//  APIManager.swift
//  Pricedive
//
//  Created by 신호연 on 2/12/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = URL(string: "http://3.37.130.95:8080")!

    private init() {}

    /// **공통 네트워크 요청 함수**
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .showLoading, object: nil)
        }

        guard let url = URL(string: baseURL.absoluteString + endpoint) else {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .hideLoading, object: nil)
            }
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
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .hideLoading, object: nil)
            }

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

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
    
    /// **전체 이벤트 리스트 가져오기**
    func fetchEvents(endpoint: String, completion: @escaping (Result<[EventDTO], NetworkError>) -> Void) {
        request(endpoint: endpoint) { (result: Result<APIResponse<[EventDTO]>, NetworkError>) in
            switch result {
            case .success(let response):
                if response.data.isEmpty {
                    print("⚠️ [APIManager] 검색 결과가 비어 있습니다.")
                }
                completion(.success(response.data))
            case .failure(let error):
                print("❌ [APIManager] 이벤트 가져오기 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    /// **좋아요한 이벤트 리스트 가져오기**
    func fetchLikedEvents(userId: Int, ongoing: Bool, completion: @escaping (Result<[LikedEventDTO], NetworkError>) -> Void) {
        let endpoint = "/like_events/user/\(userId)?ongoing=\(ongoing)"

        request(endpoint: endpoint) { (result: Result<[LikedEventDTO], NetworkError>) in
            switch result {
            case .success(let events):
                completion(.success(events))
            case .failure(let error):
                print("❌ 좋아요한 이벤트 가져오기 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    /// **좋아요 추가 / 삭제 (`POST` → 추가, `DELETE` → 삭제)**
    func toggleLike(videoId: Int, isLiked: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let userId = 1
        let urlString = "http://3.37.130.95:8080/like_events/user/\(userId)/video/\(videoId)"
            guard let url = URL(string: urlString) else { return }

            var request = URLRequest(url: url)
            request.httpMethod = isLiked ? "POST" : "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid Response", code: -1, userInfo: nil)))
                    return
                }

                if (200...299).contains(httpResponse.statusCode) {
                    completion(.success(()))
                } else {
                    let errorMessage = "HTTP 상태 코드: \(httpResponse.statusCode)"
                    completion(.failure(NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            }
            task.resume()
        }
    
    /// **특정 비디오 상세 정보 가져오기**
    func fetchVideoDetail(videoId: Int, completion: @escaping (Result<VideoDTO, NetworkError>) -> Void) {
        let url = "/videos/\(videoId)"
        print("🔍 요청 URL: \(url)")
        request(endpoint: url) { (result: Result<APIResponse<VideoDTO>, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                print("❌ 서버 요청 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
}
