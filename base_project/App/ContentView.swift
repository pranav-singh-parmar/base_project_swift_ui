//
//  ContentView.swift
//  base_project
//
//  Created by Pranav Singh on 01/08/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            CharactersListScreen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
