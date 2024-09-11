//
//  Endpoints.swift
//  base_project
//
//  Created by Pranav Singh on 17/11/22.
//

import Foundation

//MARK: - APIEndpointsProtocol
protocol APIEndpointsProtocol {
    func getURLString() -> String
}

//MARK: - BreakingBadEndpoints
enum BreakingBadEndpoints: String, APIEndpointsProtocol {
    func getURLString() -> String {
        return BreakingBadURLs.getAPIURL() + self.rawValue
    }
    
    case characters = "characters"
}

//MARK: - BreakingBadEndpointsWithParameters
enum BreakingBadEndpointsWithParameters: APIEndpointsProtocol {
    func getURLString() -> String {
        switch self {
        case .characters(let id):
            return BreakingBadURLs.getAPIURL() + "characters" + "/\(id)"
        }
    }
    
    case characters(Int)
}

//MARK: - AnimeAPIEndpoints
enum AnimeAPIEndpoints: String, APIEndpointsProtocol {
    func getURLString() -> String {
        return AnimeURLs.getAPIURL() + self.rawValue
    }
    
    case anime = "anime"
}
