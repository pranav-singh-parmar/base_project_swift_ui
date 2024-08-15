//
//  CharacterUseCase.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 17/07/24.
//

import Foundation

class GetCharactersUseCase: GetCharactersUseCaseProtocol {
    
    static let shared = GetCharactersUseCase()
    
    private let charactersREPO: any CharacterRepositoryProtocol
    
    init(charactersREPO: any CharacterRepositoryProtocol = CharacterRepositoryIMPL.shared) {
        self.charactersREPO = charactersREPO
    }
    
    func execute(withStartingFromOffset offset: Int, withLimitOf limit: Int) async -> Result<Characters, RepositoryError> {
        switch await charactersREPO.getCharacters(startingFromOffset: offset, withLimitOf: limit) {
        case .success(let characters):
            return .success(characters)
        case .failure(let error):
            return .failure(error)
        }
    }
}
