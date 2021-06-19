//
//  MainSceneInteractor.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import Foundation

final class MainSceneInteractor: MainSceneDataStore {
    
    // MARK: Properties
    
    let sampleCards: [CardViewModel] = [
        CardViewModel(id: 1, text: "Card"),
        CardViewModel(id: 2, text: "Card"),
        CardViewModel(id: 3, text: "Card"),
        CardViewModel(id: 4, text: "Card")
    ]

    var presenter: MainScenePresenting?
}

extension MainSceneInteractor: MainSceneBusinessLogic {
    func prepareContent(request: MainScene.Content.Request) {
        let response = MainScene.Content.Response(cards: sampleCards)
        presenter?.presentContent(response: response)
    }
}
