//
//  GetAnimeListUseCaseProtocol.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 25/07/24.
//

import Foundation

protocol GetAnimeListUseCaseProtocol {
    func execute(forName name: String, startingFromOffset offset: Int, withLimitOf limit: Int) async -> Result<AnimeListResponse, RepositoryError>
}
