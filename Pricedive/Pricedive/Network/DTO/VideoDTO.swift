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
    let summarizedDescription: String?

    /// dateEnd가 "0000-00-00 00:00:00"인 경우, nil로 처리
    enum CodingKeys: String, CodingKey {
        case id, title, channelId, channelImg, description, tags, urlLink, dateStart, dateEnd, summarizedDescription
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        channelId = try container.decode(String.self, forKey: .channelId)
        channelImg = try container.decode(String.self, forKey: .channelImg)
        description = try container.decode(String.self, forKey: .description)
        tags = try container.decode(String.self, forKey: .tags)
        urlLink = try container.decode(String.self, forKey: .urlLink)
        dateStart = try container.decode(String.self, forKey: .dateStart)
        summarizedDescription = try container.decodeIfPresent(String.self, forKey: .summarizedDescription)

        let rawDateEnd = try container.decode(String.self, forKey: .dateEnd)
        dateEnd = (rawDateEnd == "0000-00-00 00:00:00") ? "" : rawDateEnd
    }
}
