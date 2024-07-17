//
//  CharactersDataSource.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 12/07/24.
//

import Foundation
import Combine

protocol CharacterDataSourceProtocol {
    func getCharacters(startingFromOffset offset: Int, withLimitOf limit: Int) async throws -> Characters
}

class CharacterDataSource: CharacterDataSourceProtocol {
    func getCharacters(startingFromOffset offset: Int, withLimitOf limit: Int) async throws -> Characters {
        
        let queryParameters = ["offset": offset,
                               "limit": limit] as JSONKeyPair
        
        guard var urlRequest = URLRequest(ofHTTPMethod: .get,
                                          forAppEndpoint: .characters,
                                          withQueryParameters: queryParameters) else {
            throw DataSourceError.invalidURL
        }
        
        urlRequest.addHeaders()
        
        let (data, apiError) = await urlRequest.sendAPIRequest()
        
        guard apiError == nil else {
            if apiError is APIRequestError {
                throw DataSourceError.apiRequestError(apiError as! APIRequestError)
            } else {
                throw DataSourceError.unknown
            }
        }
        
        if let characters = data?.toStruct(Characters.self) {
            return characters
        } else {
            throw DataSourceError.decodingError
        }
    }
}
