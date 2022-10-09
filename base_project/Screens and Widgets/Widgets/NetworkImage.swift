//
//  NetworkImage.swift
//  base_project
//
//  Created by Pranav Singh on 05/08/22.
//

import SwiftUI

//struct NetworkImage: View {
//
//    private let urlString: String
//    private let contentMode: SwiftUI.ContentMode
//    // when aspect ratio increases height decreases
//    private let aspectRatio: CGFloat?
//    private let maxDimensionsGiven: Bool
//    private let width: CGFloat?
//    private let height: CGFloat?
//
//    init(urlString: String,
//         contentMode: SwiftUI.ContentMode = SwiftUI.ContentMode.fill,
//         aspectRatio: CGFloat? = nil,
//         maxDimensionsGiven: Bool = false,
//         width: CGFloat? = nil,
//         height: CGFloat? = nil) {
//        self.urlString = urlString
//        self.contentMode = contentMode
//        self.aspectRatio = aspectRatio
//        self.maxDimensionsGiven = maxDimensionsGiven
//        self.width = width
//        self.height = height
//    }
//
//    var body: some View {
//        AsyncImage(url: URL(string: urlString)) { phase in
//            Group {
//                if let image = phase.image {
//                    image // Displays the loaded image.
//                        .resizable()
//                } else if phase.error != nil {
//                    Image("") // Indicates an error.
//                        .resizable()
//                } else {
//                    ProgressView()
//                }
//            }.aspectRatio(aspectRatio, contentMode: contentMode)
//                .if (!maxDimensionsGiven) { $0.frame(width: width, height: height) }
//                .if (maxDimensionsGiven) { $0.frame(maxWidth: width, maxHeight: height) }
//        }
//    }
//}
//
//struct NetworkImage_Previews: PreviewProvider {
//    static var previews: some View {
//        NetworkImage(urlString: "")
//    }
//}
