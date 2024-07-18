//
//  CharactersListViewModel.swift
//  base_project
//
//  Created by Pranav Singh on 02/08/22.
//

import Foundation
import Combine

class CharactersListViewModel: ObservableObject {
    
    @Published private(set) var characters: [Character] = []
    
    private let getCharactersUC: any GetCharactersUseCaseProtocol
    
    private var total = 0
    private var currentLength = 0
    private(set) var getCharactersAS: ApiStatus = .notHitOnce
    
    var fetchedAllData: Bool {
        return total <= currentLength
    }
    
    init(getCharactersUC: any GetCharactersUseCaseProtocol = GetCharactersUseCase.shared) {
        self.getCharactersUC = getCharactersUC
    }
    
    func paginateWithIndex(_ index: Int) async {
        if getCharactersAS != .isBeingHit && index == currentLength - 1 && !fetchedAllData {
            await getCharacters(clearList: false)
        }
    }
    
    func getCharacters(clearList: Bool = true) async {
        getCharactersAS = .isBeingHit
        
        if clearList {
            currentLength = 0
            characters.removeAll()
        }
        
        switch await getCharactersUC.execute(withStartingFromOffset: currentLength, withLimitOf: 10) {
        case .success(let characters):
            self.total = 30
            self.characters.append(contentsOf: characters)
            self.currentLength = self.characters.count
            self.getCharactersAS = .apiHit
        case .failure(_):
            self.getCharactersAS = .apiHitWithError
        }
    }
}
