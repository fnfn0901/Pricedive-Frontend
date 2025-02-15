//
//  NetworkManager.swift
//  Pricedive
//
//  Created by 신호연 on 1/28/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(
        endpoint: Endpoint,
        baseURL: URL,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let request = endpoint.urlRequest(baseURL: baseURL) else {
            completion(.failure(NSError(domain: "Invalid URL Request", code: -1, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 요청 실패: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No Response", code: -1, userInfo: nil)))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("⚠️ 서버 오류: \(httpResponse.statusCode)")
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NSError(domain: "HTTP Error", code: statusCode, userInfo: nil)))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print("✅ 성공 응답: \(String(data: data, encoding: .utf8) ?? "No Data")")
                completion(.success(decodedData))
            } catch {
                print("⚠️ 디코딩 오류: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
