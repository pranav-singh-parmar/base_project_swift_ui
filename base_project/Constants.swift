//
//  Constants.swift
//  base_project
//
//  Created by Pranav Singh on 07/07/24.
//

import Foundation

//MARK: - AppInfo
struct AppInfo {
    static let bundleIdentifier = Bundle.main.getBundleIdentifier
    // static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    static let appCurrentVersion = Bundle.main.appCurrentVersion
    static let appName = Bundle.main.appName
    static var appId = 0
}

enum BreakingBadURLs {
    private static let baseURL = "https://www.breakingbadapi.com/"
    
    static func getAPIURL() -> String {
        return baseURL + "api/"
    }
}

//MARK: - AppURLs
class AnimeURLs {
    private static let baseURL = "https://anime-db.p.rapidapi.com/"
    
    static func getAPIURL() -> String {
        return baseURL
    }
}

