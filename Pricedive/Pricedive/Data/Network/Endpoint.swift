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
    let queryItems: [URLQueryItem]?
    let headers: [String: String]?
    let body: Data?
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.example.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
