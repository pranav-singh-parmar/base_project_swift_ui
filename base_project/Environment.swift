//
//  Environment.swift
//  base_project
//
//  Created by Pranav Singh on 27/09/24.
//

import Foundation

enum Environment {
    case testing, dev, staging, production
    
    static let current: Environment = {
        #if DEBUG
        return .testing
        #else
        return .production
        #endif
    }()
}
