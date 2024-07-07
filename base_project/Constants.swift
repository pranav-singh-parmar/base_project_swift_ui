//
//  Constants.swift
//  base_project
//
//  Created by Pranav Singh on 07/07/24.
//

import Foundation

//MARK: - AppInfo
struct AppInfo {
    static let bundleIdentifier = Bundle.main.bundleIdentifier
    // static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    static let appCurrentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    static var appId = 0
}

//MARK: - AppURLs
class AppURLs {
    private static let baseURL = "https://www.breakingbadapi.com/"
    
    static func getAPIURL() -> String {
        return baseURL + "api/"
    }
    
    //    func updateAPIURL(_ urlString: String) {
    //        apiURL = urlString
    //    }
}

