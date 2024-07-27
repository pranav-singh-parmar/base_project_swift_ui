//
//  AnimeRepositoryIMPL.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 25/07/24.
//

import Foundation

class AnimeListRepositoryIMPL: AnimeListRepositoryProtocol {
    
    static let shared = AnimeListRepositoryIMPL()
    
    private let animeListDS: any AnimeListDataSourceProtocol
    
    init(animeListDS: any AnimeListDataSourceProtocol = AnimeListDataSourceIMPL.shared) {
        self.animeListDS = animeListDS
    }
    
    func getAnimeList(forName name: String, startingFromOffset offset: Int, withLimitOf limit: Int) async -> Result<AnimeListResponse, RepositoryError> {
        switch await animeListDS.getAnimeList(forName: name,
            startingFromOffset: offset,
            withLimitOf: limit
        ) {
        case .success(let animeListResponse):
            return .success(animeListResponse)
        case .failure(let dataSourceError):
            return .failure(.dataSourceError(dataSourceError))
        }
    }
}
