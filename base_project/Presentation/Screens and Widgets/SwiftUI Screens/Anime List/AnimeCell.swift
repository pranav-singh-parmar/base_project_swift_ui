//
//  AnimeCell.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 25/07/24.
//

import SwiftUI

struct AnimeCell: View {
    private let animeModel: AnimeModel?
    
    init(_ animeModel: AnimeModel?) {
        self.animeModel = animeModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                let imageDimension = UIScreen.main.width(withMultiplier: 0.15)
                KingfisherImageView(urlString: animeModel?.image ?? "",
                                    viewModifier: NetworkImageModifier(contentMode: .fill,
                                                                      width: imageDimension,
                                                                      height: imageDimension))
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(animeModel?.title ?? "")
                        .font(.bitterBody)
                        //.fontCustom(.SemiBold, size: 20)
                        .foregroundColor(.blackColor)
                    
                    Text(animeModel?.type ?? "")
                        .font(.bitterBody)
                        //.fontCustom(.Regular, size: 15)
                        .foregroundColor(.blackColor)
                }
            }
        }
    }
}

#Preview {
    AnimeCell(nil)
}
