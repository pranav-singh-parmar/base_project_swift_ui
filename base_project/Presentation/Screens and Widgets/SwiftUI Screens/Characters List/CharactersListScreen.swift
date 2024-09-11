//
//  CharactersListScreen.swift
//  base_project
//
//  Created by Pranav Singh on 02/08/22.
//

import SwiftUI

struct CharactersListScreen: View {
    
    @StateObject private var charactersListVM = CharactersListViewModel()
    
    @State private var reader: ScrollViewProxy?
    
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            let isEmpty = charactersListVM.characters.isEmpty
            if charactersListVM.getCharactersAS.isAPIConsumed || !isEmpty {
                if isEmpty {
                    EmptyListView(text: "No Characters Found")
                } else {
                    ScrollViewReader { reader in
                        List {
                            Section(footer: !charactersListVM.fetchedAllData ?
                                    ListFooterProgressView()
                                    : nil) {
                                ForEach(Array(charactersListVM.characters.enumerated()), id: \.1) { index, character in
                                    CharacterCell(character)
                                        .padding(.horizontal, padding / 2)
                                        .padding(.vertical, padding)
                                        .onAppear {
                                            charactersListVM.paginateWithIndex(index)
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
                }
            } else {
                ScrollView {
                    ForEach(0...14, id: \.self) { index in
                        ShimmerView()
                            .frame(height: UIScreen.main.width(withMultiplier: 0.15))
                            .padding(.horizontal, padding / 2)
                            .padding(.bottom, padding)
                            .if(index == 0) { $0.padding(.top, padding) }
                    }.disabled(true)
                }
            }
        }.navigationBarTitle("Breaking Bad Cast")
            .onAppear {
                reader?.scrollTo(0)
                Task {
                    await charactersListVM.getCharacters()
                }
            }
    }
}

struct CharactersListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CharactersListScreen()
    }
}
