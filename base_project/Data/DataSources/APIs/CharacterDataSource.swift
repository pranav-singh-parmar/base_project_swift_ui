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
        
        do {
            let queryParameters = ["offset": offset,
                                   "limit": limit] as JSONKeyValuePair
            
            var urlRequest = try URLRequest(ofHTTPMethod: .get,
                                            forBreakingBadEndpoint: .characters,
                                            withQueryParameters: queryParameters)
            urlRequest.addHeaders()
            
            switch await urlRequest.sendAPIRequest() {
            case .success(_, let data):
                if let characters = data.toStruct(Characters.self) {
                    return .success(characters)
                } else {
                    return .failure(DataSourceError.decodingError)
                }
            case .failure(let error, let data):
                let errorMessage = data?.getErrorMessageFromJSONData(withAPIRequestError: error)
                return .failure(DataSourceError.apiRequestError(error, errorMessage))
            }
        } catch {
            return .failure(DataSourceError.urlRequestError(error as! URLRequestError))
        }
    }
}
