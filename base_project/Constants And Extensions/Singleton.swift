//
//  Singleton.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation

class Singleton {
    
    //Initializer access level change, now singleton class cannot be initialized again
    private init(){}
    
    static let sharedInstance = Singleton()
    
    let generalFunctions = GeneralFunctions()
    
    let alerts = Alerts()
    
    let appEnvironmentObject = AppEnvironmentObject()
    
    let jsonDecoder = JSONDecoder()
}
