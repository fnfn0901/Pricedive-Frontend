//
//  EventDTO.swift
//  Pricedive
//
//  Created by 신호연 on 2/12/25.
//


import Foundation

struct EventDTO: Decodable {
    let id: Int
    let category: String
    let eventId: Int
    let eventNums: Int
    let eventItem: String
    let previewImg: String
}
