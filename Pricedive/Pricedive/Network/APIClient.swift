//
//  APIClient.swift
//  Pricedive
//
//  Created by 신호연 on 11/22/24.
//

import Foundation

final class APIClient {
    static let shared = APIClient()
    private init() {}

    func request<T: Decodable>(
        endpoint: Endpoint,
        baseURL: URL,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = endpoint.url(baseURL: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 요청 실패: \(error.localizedDescription)")
                completion(.failure(.other(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("⚠️ 서버 오류: \(httpResponse.statusCode)")
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print("✅ 성공 응답: \(String(data: data, encoding: .utf8) ?? "No Data")")
                completion(.success(decodedData))
            } catch {
                print("⚠️ 디코딩 오류: \(error.localizedDescription)")
                completion(.failure(.decodingError))
            }
        }

        task.resume()
    }
}
