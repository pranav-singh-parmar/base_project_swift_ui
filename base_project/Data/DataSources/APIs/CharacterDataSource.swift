//
//  CharacterDataSource.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 12/07/24.
//

import Foundation
import Combine

protocol CharacterDataSourceProtocol {
    func getCharacters(startingFromOffset offset: Int, withLimitOf limit: Int) async -> DataSourceResult<Characters, DataSourceError>
}

class CharacterDataSourceIMPL: CharacterDataSourceProtocol {
    
    static let shared = CharacterDataSourceIMPL()
    
    func getCharacters(startingFromOffset offset: Int, withLimitOf limit: Int) async -> DataSourceResult<Characters, DataSourceError> {
        
        let queryParameters = ["offset": offset,
                               "limit": limit] as JSONKeyValuePair
        
        do {
            var urlRequest = try URLRequest(ofHTTPMethod: .get,
                                        forAppEndpoint: .characters,
                                        withQueryParameters: queryParameters)
            urlRequest.addHeaders()
            
            switch await urlRequest.sendAPIRequest() {
            case .success(let data):
                if let characters = data.toStruct(Characters.self) {
                    return .success(characters)
                } else {
                    return .failure(DataSourceError.decodingError)
                }
            case .failure(let error, let data):
                return .failure(DataSourceError.apiRequestError(error))
            }
        } catch {
            return .failure(DataSourceError.urlRequestError(error as! URLRequestError))
        }
    }
}
