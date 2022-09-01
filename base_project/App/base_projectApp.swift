//
//  base_projectApp.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import SwiftUI

@main
struct base_projectApp: App {
    
    @StateObject var network = InternetConnectivityViewModel()
    
    @ObservedObject private var appEnvironmentObject = Singleton.sharedInstance.appEnvironmentObject
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if appEnvironmentObject.changeContentView {
                    ContentView()
                        .environmentObject(appEnvironmentObject)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                } else {
                    ContentView()
                        .environmentObject(appEnvironmentObject)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
                }
            }.animation(Animation.easeIn, value: appEnvironmentObject.changeContentView)
        }
    }
}
