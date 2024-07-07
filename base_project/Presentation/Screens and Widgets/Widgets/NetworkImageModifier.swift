//
//  NetworkImageModifier.swift
//  base_project_api_integration
//
//  Created by MacBook PRO on 18/10/23.
//

import SwiftUI

struct NetworkImageModifier: ViewModifier {
    
    // when aspect ratio increases height decreases
    // a = w/h
    private let aspectRatio: CGFloat?
    private let contentMode: SwiftUI.ContentMode
    private let width: CGFloat?
    private let height: CGFloat?
    
    init (aspectRatio: CGFloat? = nil,
          contentMode: SwiftUI.ContentMode = .fit,
          width: CGFloat? = nil,
          height: CGFloat? = nil) {
        self.aspectRatio = aspectRatio
        self.contentMode = contentMode
        self.height = height
        self.width = width
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if (height == .infinity || width == .infinity) {
            self.content(content)
                .frame(maxWidth: getWidth, maxHeight: getHeight)
        } else {
            self.content(content)
                .frame(width: getWidth, height: getHeight)
        }
    }
    
    @ViewBuilder
    func content(_ content: Content) -> some View {
        content
            .aspectRatio(aspectRatio, contentMode: contentMode)
    }
    
    //aspect ratio = width/height
    var getHeight: CGFloat? {
        if let height {
            return height
        } else if let aspectRatio, let width, width != .infinity {
            return width / aspectRatio
        }
        return nil
    }
    
    var getWidth: CGFloat? {
        if let width {
            return width
        } else if let aspectRatio, let height, height != .infinity {
            return height * aspectRatio
        }
        return nil
    }
}


//struct NetworkImageModifier_Previews: PreviewProvider {
//    static var previews: some View {
//        NetworkImageModifier()
//    }
//}
