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
            
            let headers = ["X-RapidAPI-Key": "2b975442demsh14dd8bb5a692b60p17c702jsnc458dbd221ae",
                           "X-RapidAPI-Host": "anime-db.p.rapidapi.com"] as JSONKeyValuePair
            
            urlRequest.addHeaders(headers)
            
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
