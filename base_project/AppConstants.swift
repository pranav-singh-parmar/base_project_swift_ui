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
