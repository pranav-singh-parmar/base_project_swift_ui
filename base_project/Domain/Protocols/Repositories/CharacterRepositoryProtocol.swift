//
//  CharacterRepositoryProtocol.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 17/07/24.
//

import Foundation

protocol CharacterRepositoryProtocol {
    func getCharacters(startingFromOffset offset: Int, withLimitOf limit: Int) async -> Result<Characters, RepositoryError>
}
