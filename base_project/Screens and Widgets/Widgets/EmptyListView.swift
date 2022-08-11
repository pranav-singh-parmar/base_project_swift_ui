//
//  EmptyListView.swift
//  base_project
//
//  Created by Pranav Singh on 05/08/22.
//

import SwiftUI

struct EmptyListView: View {
    private let imageName: String
    private let text: String
    
    private let dimensions: CGFloat = 200//UIScreen.main.bounds.size.width - 2
    
    init (imageName: String = "noDataImage", text: String = "No Data Available"){
        self.imageName = imageName
        self.text = text
    }
    
    var body: some View {
        
        VStack{
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 20) {
                    Text(text)
                        .fontCustom(.Regular, size: 18)
                        .foregroundColor(.blackColor)
                }
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
