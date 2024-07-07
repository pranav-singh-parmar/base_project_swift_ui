//
//  Extensions.swift
//  base_project
//
//  Created by Pranav Singh on 07/07/24.
//

import Foundation

//MARK: - Bundle
extension Bundle {
    var getBundleIdentifier: String? {
        return Bundle.main.bundleIdentifier
        //return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    var appCurrentVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
}
