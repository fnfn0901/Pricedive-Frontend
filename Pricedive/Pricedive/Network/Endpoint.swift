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

    func urlRequest(baseURL: URL) ->URLRequest? {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        if let queryParameters = queryParameters {
            components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components?.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let bodyParameters = bodyParameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParameters)
        }
        
        if let headers = headers {
            headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        return request
    }
}
