//
//  CharactersListViewModel.swift
//  base_project
//
//  Created by Pranav Singh on 02/08/22.
//

import Foundation
import Combine

@MainActor class CharactersListViewModel: ObservableObject {
    
    @Published  private(set) var getCharactersAS: APIRequestStatus = .notConsumedOnce
    
    private let getCharactersUC: any GetCharactersUseCaseProtocol
    
    private var total = 0
    private var currentLength = 0
    private(set) var characters: [Character] = []
    
    var fetchedAllData: Bool {
        return total <= currentLength
    }
    
    init(getCharactersUC: any GetCharactersUseCaseProtocol = GetCharactersUseCase.shared) {
        self.getCharactersUC = getCharactersUC
    }
    
    func paginateWithIndex(_ index: Int) {
        if getCharactersAS != .isBeingConsumed && index == currentLength - 1 && !fetchedAllData {
            Task {
                await getCharacters(clearList: false)
            }
        }
    }
    
    func getCharacters(clearList: Bool = true) async {
        getCharactersAS = .isBeingConsumed
        
        if clearList {
            currentLength = 0
            characters.removeAll()
        }
        
        switch await getCharactersUC.execute(withStartingFromOffset: currentLength, withLimitOf: 10) {
        case .success(let characters):
            self.total = 30
            self.characters.append(contentsOf: characters)
            self.currentLength = self.characters.count
            self.getCharactersAS = .consumedWithSuccess
        case .failure(let error):
            switch error {
            case .dataSourceError(let dataSourceError):
                switch dataSourceError {
                case .apiRequestError(let apiRequestError, let message):
                    switch apiRequestError {
                    case .internetNotConnected:
                        Singleton.sharedInstance.alerts.internetNotConnectedAlert {
                            Task { [weak self] in
                                await self?.getCharacters(clearList: clearList)
                            }
                        }
                    case .clientError(let clientError):
                        if case .unauthorised = clientError {
                            Singleton.sharedInstance.alerts.handle401StatueCode()
                        }
                    default:
                        if let message {
                            Singleton.sharedInstance.alerts.errorAlertWith(message: message)
                        }
                        break
                    }
                default:
                    break
                }
                self.getCharactersAS = .consumedWithError
            }
        }
    }
}
