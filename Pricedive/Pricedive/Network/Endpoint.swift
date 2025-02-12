//
//  Endpoint.swift
//  Pricedive
//
//  Created by 신호연 on 1/20/25.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let queryParameters: [String: String]?
    let bodyParameters: [String: Any]?
    let headers: [String: String]?

    /// URL 생성
    func url(baseURL: URL) -> URL? {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        if let queryParameters = queryParameters {
            components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components?.url
    }

    /// JSON Body 데이터 반환
    var body: Data? {
        guard let bodyParameters = bodyParameters else { return nil }
        return try? JSONSerialization.data(withJSONObject: bodyParameters, options: [])
    }

    /// HTTP 요청 생성
    func urlRequest(baseURL: URL) -> URLRequest? {
        guard let url = url(baseURL: baseURL) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let headers = headers {
            headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        return request
    }
}
