//
//  AnimeListViewModel.swift
//  base_project
//
//  Created by Pranav Singh Parmar on 25/07/24.
//

import Foundation
import Combine

@MainActor class AnimeListViewModel: ObservableObject {
    
    @Published private(set) var getAnimeListAS: APIRequestStatus = .notConsumedOnce
    
    private let getAnimeListUC: any GetAnimeListUseCaseProtocol
    
    private var total = 0
    private var currentLength = 1
    private(set) var animeList: [AnimeModel] = []
    
    var fetchedAllData: Bool {
        return total <= currentLength
    }
    
    init(getAnimeListUC: any GetAnimeListUseCaseProtocol = GetAnimeListUseCase.shared) {
        self.getAnimeListUC = getAnimeListUC
    }
    
    func paginateWithIndex(_ index: Int) {
        if getAnimeListAS != .isBeingConsumed && index == currentLength - 1 && !fetchedAllData {
            Task {
                await getAnimeList(clearList: false)
            }
        }
    }
    
    func getAnimeList(clearList: Bool = true) async {
        getAnimeListAS = .isBeingConsumed
        
        if clearList {
            currentLength = 1
            animeList.removeAll()
        }
        
        switch await getAnimeListUC.execute(forName: "Dragon Ball Z",
                                            startingFromOffset: currentLength,
                                            withLimitOf: 10) {
        case .success(let animeListResponse):
            self.total = 30
            if let animeList = animeListResponse.data {
                self.animeList.append(contentsOf: animeList)
            }
            self.currentLength = self.animeList.count
            self.getAnimeListAS = .consumedWithSuccess
        case .failure(let error):
            switch error {
            case .dataSourceError(let dataSourceError):
                switch dataSourceError {
                case .apiRequestError(let apiRequestError, let message):
                    switch apiRequestError {
                    case .internetNotConnected:
                        Singleton.sharedInstance.alerts.internetNotConnectedAlert {
                            Task { [weak self] in
                                await self?.getAnimeList(clearList: clearList)
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
                self.getAnimeListAS = .consumedWithError
            }
        }
    }
}
