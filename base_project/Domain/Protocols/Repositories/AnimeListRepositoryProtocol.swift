//
//  AnimeListRepositoryProtocol.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 25/07/24.
//

import Foundation

protocol AnimeListRepositoryProtocol {
    func getAnimeList(forName name: String, startingFromOffset offset: Int, withLimitOf limit: Int) async -> Result<AnimeListResponse, RepositoryError>
}
