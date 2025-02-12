//
//  VideoDTO.swift
//  Pricedive
//
//  Created by 신호연 on 2/12/25.
//

import Foundation

struct VideoDTO: Decodable {
    let id: Int
    let title: String
    let channelId: String
    let channelImg: String
    let description: String
    let tags: String
    let urlLink: String
    let dateStart: String
    let dateEnd: String
    let summarizedDescription: String
}
