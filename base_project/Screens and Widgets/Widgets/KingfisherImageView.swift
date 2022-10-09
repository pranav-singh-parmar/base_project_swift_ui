//
//  KingfisherImageView.swift
//  base_project
//
//  Created by Pranav Singh on 09/10/22.
//

import SwiftUI
import Kingfisher

struct KingfisherImageView: View {
    private let urlString: String
    // when aspect ratio increases height decreases
    private let aspectRatio: CGFloat?
    private let contentMode: SwiftUI.ContentMode
    private let maxDimensionsGiven: Bool
    private let width: CGFloat?
    private let height: CGFloat?
    
    init(urlString: String = "",
         aspectRatio: CGFloat? = nil,
         contentMode: SwiftUI.ContentMode = SwiftUI.ContentMode.fill,
         maxDimensionsGiven: Bool = false,
         width: CGFloat? = nil,
         height: CGFloat? = nil) {
        self.urlString = urlString
        self.aspectRatio = aspectRatio
        self.contentMode = contentMode
        self.maxDimensionsGiven = maxDimensionsGiven
        self.width = width
        self.height = height
    }
    
    var body: some View {
        KFImage.url(URL(string: urlString))
            .fade(duration: 1)
            .placeholder {
                Image("placeholderImage")
                    .resizable()
                    .aspectRatio(aspectRatio, contentMode: contentMode)
                    .if (!maxDimensionsGiven) { $0.frame(width: width, height: height) }
                    .if (maxDimensionsGiven) { $0.frame(maxWidth: width, maxHeight: height) }
            }
            .cacheOriginalImage()
            .resizable()
            .aspectRatio(aspectRatio, contentMode: contentMode)
            .if (!maxDimensionsGiven) { $0.frame(width: width, height: height) }
            .if (maxDimensionsGiven) { $0.frame(maxWidth: width, maxHeight: height) }
    }

}

struct KingfisherImageView_Previews: PreviewProvider {
    static var previews: some View {
        KingfisherImageView()
    }
}
