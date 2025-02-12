//
//  APIManager.swift
//  Pricedive
//
//  Created by 신호연 on 2/12/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = URL(string: "http://192.168.10.17:8080")!

    private init() {}

    /// 전체 이벤트 리스트 가져오기
    func fetchEvents(completion: @escaping (Result<[EventDTO], NetworkError>) -> Void) {
        let endpoint = "/events"
        guard let url = URL(string: baseURL.absoluteString + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

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
                let apiResponse = try JSONDecoder().decode(APIResponse<[EventDTO]>.self, from: data)
                completion(.success(apiResponse.data))
            } catch {
                completion(.failure(.decodingError))
            }
        }

        task.resume()
    }

    /// 특정 이벤트 상세 정보 가져오기
    func fetchEventDetail(eventId: Int, completion: @escaping (Result<EventDTO, NetworkError>) -> Void) {
        let endpoint = "/events/\(eventId)"
        guard let url = URL(string: baseURL.absoluteString + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

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
                let apiResponse = try JSONDecoder().decode(APIResponse<EventDTO>.self, from: data)
                completion(.success(apiResponse.data))
            } catch {
                completion(.failure(.decodingError))
            }
        }

        task.resume()
    }
}
