//
//  ShimmerView.swift
//  base_project
//
//  Created by Pranav Singh on 05/08/22.
//

import SwiftUI

//https://medium.com/@Mary_Dort/shimmer-effect-with-swiftui-cbe02946c12f
struct ShimmerView: View {
        
    @State private var opacity: Double
    
    private let duration: Double = 1.5
    private let minOpacity: Double = 0.5
    private let maxOpacity: Double = 1
    private let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat = 5) {
        self.cornerRadius = cornerRadius
        opacity = minOpacity
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.placeholderColor)
            .opacity(opacity)
            .transition(.opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    let baseAnimation = Animation.easeInOut(duration: duration)
                    let repeated = baseAnimation.repeatForever(autoreverses: true)
                    withAnimation(repeated) {
                        self.opacity = maxOpacity
                    }
                }
            }
    }
}

struct ShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerView()
    }
}
