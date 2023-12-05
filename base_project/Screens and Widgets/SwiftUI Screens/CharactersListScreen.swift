//
//  CharactersListScreen.swift
//  base_project
//
//  Created by Pranav Singh on 02/08/22.
//

import SwiftUI

struct CharactersListScreen: View {
    
    @StateObject private var charactersVM = CharactersViewModel()
    
    @State private var reader: ScrollViewProxy?
    
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            let count = charactersVM.characters.count
            if charactersVM.getCharactersAS == .apiHit && count == 0 {
                EmptyListView(text: "No Characters Found")
            } else if charactersVM.getCharactersAS == .apiHit || count != 0 {
                ScrollViewReader { reader in
                    List {
                        Section(footer: !charactersVM.fetchedAllData ?
                                ListFooterProgressView()
                                : nil) {
                            ForEach(Array(charactersVM.characters.enumerated()), id: \.1) { index, character in
                                CharacterCell(character)
                                    .padding(.horizontal, padding / 2)
                                    .padding(.bottom, padding)
                                    .if(index == 0) { $0.padding(.top, padding) }
                                    .onAppear {
                                        charactersVM.paginateWithIndex(index)
                                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    .listRowBackground(Color.clear)
                                    .id(index)
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }.listStyle(PlainListStyle())
                        .onTapGesture {
                            return
                        }
                        .onLongPressGesture(minimumDuration: 0.1) {
                            return
                        }.onAppear {
                            self.reader = reader
                        }
                }
            } else {
                ScrollView {
                    ForEach(0...14, id: \.self) { index in
                        ShimmerView()
                            .frame(height: DeviceDimensions.width(withMultiplier: 0.15))
                            .padding(.horizontal, padding / 2)
                            .padding(.bottom, padding)
                            .if(index == 0) { $0.padding(.top, padding) }
                    }.disabled(true)
                }
            }
        }.navigationBarTitle("Breaking Bad Cast")
            .onAppear {
                reader?.scrollTo(0)
                charactersVM.getCharacters()
            }
    }
}

struct CharactersListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CharactersListScreen()
    }
}
