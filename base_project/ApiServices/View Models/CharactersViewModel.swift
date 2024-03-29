//
//  CharactersViewModel.swift
//  base_project
//
//  Created by Pranav Singh on 02/08/22.
//

import Foundation
import Combine

class CharactersViewModel: ObservableObject {
    
    private var cancellable: Set<AnyCancellable> = []
    
    @Published private(set) var characters: [Character] = []
    
    private var total = 0
    private var currentLength = 0
    private(set) var getCharactersAS: ApiStatus = .notHitOnce
    
    var fetchedAllData: Bool {
        return total <= currentLength
    }
    
    func paginateWithIndex(_ index: Int) {
        if getCharactersAS != .isBeingHit && index == currentLength - 1 && !fetchedAllData {
            getCharacters(clearList: false)
        }
    }
    
    func getCharacters(clearList: Bool = true){
        getCharactersAS = .isBeingHit
        
        if clearList {
            currentLength = 0
            characters.removeAll()
        }
        
        let params = ["limit": 10, "offset": currentLength] as JSONKeyPair
        
        var urlRequest = URLRequest(ofHTTPMethod: .get,
                                    forAppEndpoint: .characters,
                                    withQueryParameters: params)
        
        urlRequest?.addHeaders()
        
        urlRequest?.hitApi(decodingStruct: Characters.self) { [weak self] in
            self?.getCharacters(clearList: clearList)
        }
        .sink{ [weak self] completion in
            switch completion {
            case .finished:
                self?.getCharactersAS = .apiHit
                break
            case .failure(_):
                self?.getCharactersAS = .apiHitWithError
                break
            }
        } receiveValue: { [weak self] response in
            self?.total = 30
            self?.characters.append(contentsOf: response)
            self?.currentLength = self?.characters.count ?? 0
        }.store(in: &cancellable)
    }
}
