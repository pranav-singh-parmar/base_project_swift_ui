//
//  Endpoints.swift
//  base_project
//
//  Created by Pranav Singh on 17/11/22.
//

import Foundation

//MARK: - Endpoints
protocol EndpointsProtocol {
    func getURLString() -> String
}

//MARK: - AppEndpoints
enum AppEndpoints: String, EndpointsProtocol {
    func getURLString() -> String {
        return AppConstants.AppURLs.apiURL + self.rawValue
    }
    
    case characters = "characters"
}

//MARK: - AppEndpoints
enum AppEndpointsWithParamters: EndpointsProtocol {
    func getURLString() -> String {
        switch self {
        case .characters(let id):
            return AppConstants.AppURLs.apiURL + "characters" + "/\(id)"
        }
    }
    
    case characters(Int)
}

//MARK: - AppleAPIEndpoints
enum AppleAPIEndpoints: String, EndpointsProtocol {
    func getURLString() -> String {
        return AppConstants.AppURLs.apiURL + self.rawValue
    }
    
    case characters = "characters"
}
