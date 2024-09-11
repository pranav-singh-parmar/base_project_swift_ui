//
//  GetCharactersUseCaseProtocol.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 17/07/24.
//

import Foundation

protocol GetCharactersUseCaseProtocol {
    func execute(withStartingFromOffset offset: Int, withLimitOf limit: Int) async -> Result<Characters, RepositoryError>
}
