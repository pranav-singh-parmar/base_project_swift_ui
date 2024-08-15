//
//  AnimeListResponse.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 25/07/24.
//

import Foundation

// MARK: - AnimeListResponse
struct AnimeListResponse: Codable {
    let data: [AnimeModel]?
    let meta: MetaModel?
}

// MARK: - AnimeModel
struct AnimeModel: Codable, Hashable {
    let id, title: String?
    let alternativeTitles: [String]?
    let ranking: Int?
    let genres: [String]?
    let episodes: Int?
    let hasEpisode, hasRanking: Bool?
    let image: String?
    let link: String?
    let status: String?
    let synopsis: String?
    let thumb: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title, alternativeTitles, ranking, genres, episodes, hasEpisode, hasRanking, image, link, status, synopsis, thumb, type
    }
}

// MARK: - MetaModel
struct MetaModel: Codable {
    let page, size, totalData, totalPage: Int?
}
