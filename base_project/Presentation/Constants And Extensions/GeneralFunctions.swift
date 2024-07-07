//
//  GeneralFunctions.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation
import UIKit
import CoreTelephony
import SwiftUI

class GeneralFunctions {
    func deinitilseAllVariables() {
        //remove all user default values
        let domain = AppInfo.bundleIdentifier ?? ""
        UserDefaults.standard.removePersistentDomain(forName: domain)
        
        Singleton.sharedInstance.appEnvironmentObject.changeContentView.toggle()
    }
}
