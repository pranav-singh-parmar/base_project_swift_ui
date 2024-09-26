//
//  ServerURLs.swift
//  base_project
//
//  Created by Pranav Singh on 25/09/24.
//

import Foundation

enum ServerURLs {
    case breakingBad(_ environment: Environment),
         anime(_ environment: Environment)
    
    //MARK: - Convenience initialisers
    /// To use the default environment
    static func breakingBad() -> ServerURLs {
        return .breakingBad(Environment.current)
    }
    
    /// To use the default environment
    static func anime() -> ServerURLs {
        return .anime(Environment.current)
    }
    
    //MARK: - Static properties
    /// With closures which will be executed once
    //    static let breakingBad: ServerURLs = {
    //        return .breakingBad(Environment.current)
    //    }()
    //
    /// With closures which will be executed once
    //    static let anime: ServerURLs = {
    //        return .breakingBad(Environment.current)
    //    }()
    
    //MARK: - Base URLs
    var baseURL: String {
        switch self {
        case .breakingBad(let environment):
            switch environment {
            default:
                "https://www.breakingbadapi.com/"
            }
        case .anime(let environment):
            switch environment {
            default:
                "https://anime-db.p.rapidapi.com/"
            }
        }
    }
    
    //MARK: - API URLs
    var apiURL: String {
        switch self {
        case .breakingBad(let environment):
            switch environment {
            default:
                return baseURL + "api/"
            }
        case .anime(let environment):
            switch environment {
            default:
                return baseURL
            }
        }
    }
}
