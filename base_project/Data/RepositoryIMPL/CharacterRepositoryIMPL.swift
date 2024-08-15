//
//  CharacterRepositoryIMPL.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 17/07/24.
//

import Combine

class CharacterRepositoryIMPL: CharacterRepositoryProtocol {
    
    static let shared = CharacterRepositoryIMPL()
    
    private let characterDS: any CharacterDataSourceProtocol
    
    init(characterDS: any CharacterDataSourceProtocol = CharacterDataSourceIMPL.shared) {
        self.characterDS = characterDS
    }
    
    func getCharacters(startingFromOffset offset: Int, withLimitOf limit: Int) async -> Result<Characters, RepositoryError> {
        switch await characterDS.getCharacters(
            startingFromOffset: offset,
            withLimitOf: limit
        ) {
        case .success(let characters):
            return .success(characters)
        case .failure(let dataSourceError):
            return .failure(.dataSourceError(dataSourceError))
        }
    }
}
