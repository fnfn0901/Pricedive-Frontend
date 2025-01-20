//
//  NetworkError.swift
//  Pricedive
//
//  Created by 신호연 on 1/20/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noResponse
    case serverError(statusCode: Int)
    case noData
    case decodingError
    case other(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noResponse: return "No response from server."
        case .serverError(let statusCode): return "Server error with status code: \(statusCode)."
        case .noData: return "No data received."
        case .decodingError: return "Failed to decode data."
        case .other(let error): return error.localizedDescription
        }
    }
}
