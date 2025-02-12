//
//  APIResponse.swift
//  Pricedive
//
//  Created by 신호연 on 2/12/25.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let data: T
}
