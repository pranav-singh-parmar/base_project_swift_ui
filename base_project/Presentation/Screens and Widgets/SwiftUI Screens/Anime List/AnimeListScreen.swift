//
//  AnimeListScreen.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 25/07/24.
//

import SwiftUI

struct AnimeListScreen: View {
    
    @StateObject private var animeListVM = AnimeListViewModel()
    
    @State private var reader: ScrollViewProxy?
    
    private let padding: CGFloat = 16
    
    var body: some View {
        ZStack {
            let isEmpty = animeListVM.animeList.isEmpty
            if animeListVM.getAnimeListAS.isAPIConsumed || !isEmpty {
                if isEmpty {
                    EmptyListView(text: "No Anime's Found")
                } else {
                    ScrollViewReader { reader in
                        List {
                            Section(footer: !animeListVM.fetchedAllData ?
                                    ListFooterProgressView()
                                    : nil) {
                                ForEach(Array(animeListVM.animeList.enumerated()), id: \.1) { index, animeModel in
                                    AnimeCell(animeModel)
                                        .padding(.horizontal, padding / 2)
                                        .padding(.vertical, padding)
                                        .onAppear {
                                            animeListVM.paginateWithIndex(index)
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
        }.navigationBarTitle("Anime List")
            .onAppear {
                reader?.scrollTo(0)
                Task {
                    await animeListVM.getAnimeList()
                }
            }
    }
}

#Preview {
    AnimeListScreen()
}
