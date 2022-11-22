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
        return AppConfig.getAPIURL() + self.rawValue
    }
    
    case characters = "characters"
}

//MARK: - AppEndpoints
enum AppEndpointsWithParamters: EndpointsProtocol {
    func getURLString() -> String {
        switch self {
        case .characters(let id):
            return AppConfig.getAPIURL() + "characters" + "/\(id)"
        }
    }
    
    case characters(Int)
}

//MARK: - AppleAPIEndpoints
enum AppleAPIEndpoints: String, EndpointsProtocol {
    func getURLString() -> String {
        return AppConfig.getAPIURL() + self.rawValue
    }
    
    case characters = "characters"
}
