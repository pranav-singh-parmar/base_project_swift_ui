//
//  CharactersViewModel.swift
//  base_project
//
//  Created by Pranav Singh on 02/08/22.
//

import Foundation
import Combine

class CharactersViewModel: ViewModel {
    
    private var cancellable: Set<AnyCancellable> = []
    
    @Published private(set) var characters: [Character] = []
    
    private var total = 0
    private var currentLength = 0
    private(set) var getCharactersAS: ApiStatus = .NotHitOnce

    var fetchedAllData: Bool {
        return total <= currentLength
    }
    
    func paginateWithIndex(_ index: Int) {
        if getCharactersAS != .IsBeingHit && index == currentLength - 1 && !fetchedAllData {
            getCharacters(clearList: false)
        }
    }
    
    func getCharacters(clearList: Bool = true){
        getCharactersAS = .IsBeingHit
        
        if clearList {
            currentLength = 0
            characters.removeAll()
        }
        
        let params = ["limit": 10, "offset": currentLength] as [String: Any]
        
        Singleton.sharedInstance.apiServices.hitApi(httpMethod: .GET, urlString: AppConstants.ApiEndPoints.characters, isAuthApi: false, parameterEncoding: .QueryParameters, params: params, decodingStruct: Characters.self) { [weak self] in
                self?.getCharacters(clearList: clearList)
            }
            .sink{ [weak self] completion in
                switch completion {
                    case .finished:
                    self?.getCharactersAS = .ApiHit
                    break
                    case .failure(_):
                    self?.getCharactersAS = .ApiHitWithError
                    break
                }
            } receiveValue: { [weak self] response in
                print("here in value \(response.count)")
                self?.total = 30
                self?.characters.append(contentsOf: response)
                self?.currentLength = self?.characters.count ?? 0
            }.store(in: &cancellable)
    }
    
    func clearAllCancellables() {
        cancellable.cancelAll()
    }
}
