//
//  ListFooterProgressView.swift
//  base_project
//
//  Created by Pranav Singh on 05/08/22.
//

import SwiftUI

struct ListFooterProgressView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView().padding(.top)
            Spacer()
        }.listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .buttonStyle(PlainButtonStyle())
    }
}

struct ListFooterProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ListFooterProgressView()
    }
}
