//
//  AnimeListDataSourceProtocol.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 24/07/24.
//

import Foundation
import Combine

protocol AnimeListDataSourceProtocol {
    func getAnimeList(forName name: String, startingFromOffset offset: Int, withLimitOf limit: Int) async -> DataSourceResult<AnimeListResponse, DataSourceError>
}

class AnimeListDataSourceIMPL: AnimeListDataSourceProtocol {
    
    static let shared = AnimeListDataSourceIMPL()
    
    func getAnimeList(forName name: String, startingFromOffset offset: Int, withLimitOf limit: Int) async -> DataSourceResult<AnimeListResponse, DataSourceError> {
        
        do {
            let queryParameters = ["search": name,
                                   "page": offset,
                                   "size": limit] as JSONKeyValuePair
            
            var urlRequest = try URLRequest(ofHTTPMethod: .get,
                                            forAnimeEndpoint: .anime,
                                            withQueryParameters: queryParameters)
            
            urlRequest.setHeadersFor(.anime())
            
            switch await urlRequest.sendAPIRequest() {
            case .success(_, let data):
                if let animeListResponse = data.toStruct(AnimeListResponse.self) {
                    return .success(animeListResponse)
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
