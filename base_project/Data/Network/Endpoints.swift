//
//  Endpoints.swift
//  base_project
//
//  Created by Pranav Singh on 17/11/22.
//

import Foundation

//MARK: - APIEndpointsProtocol
protocol APIEndpointsProtocol {
    var endpoint: String { get }
    
    func getURLString() -> String
}

//MARK: - BreakingBadEndpoints
enum BreakingBadEndpoints: APIEndpointsProtocol {
    case characters,
         character(withID: Int)
    
    var endpoint: String {
        switch self {
        case .characters:
            return "characters"
        case .character(withID: let id):
            return "characters" + "/\(id)"
        }
    }
    
    func getURLString() -> String {
        return ServerURLs.breakingBad().apiURL + self.endpoint
    }
}

//MARK: - AnimeAPIEndpoints
enum AnimeAPIEndpoints: APIEndpointsProtocol {
    case anime
    
    var endpoint: String {
        switch self {
        case .anime:
            return "anime"
        }
    }
    
    func getURLString() -> String {
        return ServerURLs.anime().apiURL + self.endpoint
    }
}
