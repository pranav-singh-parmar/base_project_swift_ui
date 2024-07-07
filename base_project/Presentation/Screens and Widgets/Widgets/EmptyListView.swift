//
//  EmptyListView.swift
//  base_project
//
//  Created by Pranav Singh on 05/08/22.
//

import SwiftUI

struct EmptyListView: View {
    
    private let text: String
    
    init(text: String = AppTexts.noDataAvailable){
        self.text = text
    }
    
    var body: some View {
        VStack{
            Spacer()
            HStack {
                Spacer()
                Text(text)
                    .font(.bitterBody)
                    .foregroundColor(.blackColor)
                Spacer()
            }
            Spacer()
        }
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
    }
}
