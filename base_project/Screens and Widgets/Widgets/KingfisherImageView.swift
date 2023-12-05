//
//  KingfisherImageView.swift
//  base_project_api_integration
//
//  Created by MacBook PRO on 18/10/23.
//

import SwiftUI
import Kingfisher

struct KingfisherImageView<Transform> : View where Transform : ViewModifier {
    
    private let urlString: String
    // when aspect ratio increases height decreases
    // a = w/h
    private let viewModifier: Transform
    
    init(urlString: String = "",
         viewModifier: Transform) {
        self.urlString = urlString
        self.viewModifier = viewModifier
    }
    
    var body: some View {
        kingfisherIV
            .modifier(viewModifier)
    }
    
    private var kingfisherIV: some View {
        return KFImage.url(URL(string: urlString))
            .fade(duration: 1)
            .placeholder {
                placeholder
            }
            .cacheOriginalImage()
            .resizable()
    }
    
    private var placeholder: some View {
        Image("placeholderImage")
            .resizable()
            .modifier(viewModifier)
    }
}

struct KingfisherImageView_Previews: PreviewProvider {
    static var previews: some View {
        KingfisherImageView(urlString: "https://picsum.photos/250?image=9",
                            viewModifier: NetworkImageModifier())
    }
}
