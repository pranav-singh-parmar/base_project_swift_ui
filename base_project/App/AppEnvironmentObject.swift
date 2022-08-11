//
//  AppEnvironmentObject.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import Foundation

//MARK: - AppEnvironmentObject
final class AppEnvironmentObject: ObservableObject {
    // suppose user log outs so send user to home screen
    @Published var changeContentView: Bool = false
    // for internet status, connected or not
    @Published var isConnectedToInternet: Bool = true
}
