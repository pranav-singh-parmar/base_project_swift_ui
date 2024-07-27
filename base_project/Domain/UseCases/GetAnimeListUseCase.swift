//
//  GetAnimeListUseCase.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 25/07/24.
//

import Foundation

class GetAnimeListUseCase: GetAnimeListUseCaseProtocol {
    
    static let shared = GetAnimeListUseCase()
    
    private let animeListREPO: any AnimeListRepositoryProtocol
    
    init(animeListREPO: any AnimeListRepositoryProtocol = AnimeListRepositoryIMPL.shared) {
        self.animeListREPO = animeListREPO
    }
    
    func execute(forName name: String, startingFromOffset offset: Int, withLimitOf limit: Int) async -> Result<AnimeListResponse, RepositoryError> {
        switch await animeListREPO.getAnimeList(forName: name,
                                                startingFromOffset: offset,
                                                withLimitOf: limit) {
        case .success(let animeListResponse):
            return .success(animeListResponse)
        case .failure(let error):
            return .failure(error)
        }
    }
}
