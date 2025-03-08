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
    let description: String
    let tags: String
    let channelId: String
    let channelImg: String
    let urlLink: String
    let dateStart: String
    let dateEnd: String
    let summarizedDescription: String?
    let previewImg: String?

    enum CodingKeys: String, CodingKey {
        case id, title, description, tags, channelId, channelImg, urlLink, dateStart, dateEnd, summarizedDescription, previewImg
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "제목 없음"
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? "설명 없음"
        tags = try container.decodeIfPresent(String.self, forKey: .tags) ?? ""
        channelId = try container.decodeIfPresent(String.self, forKey: .channelId) ?? ""
        channelImg = try container.decodeIfPresent(String.self, forKey: .channelImg) ?? ""
        urlLink = try container.decodeIfPresent(String.self, forKey: .urlLink) ?? "https://default-url.com"
        dateStart = try container.decodeIfPresent(String.self, forKey: .dateStart) ?? ""
        dateEnd = try container.decodeIfPresent(String.self, forKey: .dateEnd) ?? ""
        summarizedDescription = try container.decodeIfPresent(String.self, forKey: .summarizedDescription)
        previewImg = try container.decodeIfPresent(String.self, forKey: .previewImg)
    }
}
