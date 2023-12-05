//
//  CharacterCell.swift
//  base_project
//
//  Created by Pranav Singh on 10/08/22.
//

import SwiftUI

struct CharacterCell: View {
    
    private let characterModel: Character?
    
    init(_ characterModel: Character?) {
        self.characterModel = characterModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                let imageDimension = DeviceDimensions.width(withMultiplier: 0.15)
                KingfisherImageView(urlString: characterModel?.img ?? "",
                                    viewModifier: NetworkImageModifier(contentMode: .fill,
                                                                      width: imageDimension,
                                                                      height: imageDimension))
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(characterModel?.name ?? "")
                        .font(.bitterBody)
                        //.fontCustom(.SemiBold, size: 20)
                        .foregroundColor(.blackColor)
                    
                    Text(characterModel?.portrayed ?? "")
                        .font(.bitterBody)
                        //.fontCustom(.Regular, size: 15)
                        .foregroundColor(.blackColor)
                }
            }
        }
    }
}

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell(nil)
    }
}
