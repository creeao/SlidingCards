//
//  MainScenePresenter.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import Foundation

final class MainScenePresenter: MainScenePresentationSetup {
    weak var viewController: MainSceneDisplayLogic?
    
    func attach(viewController: MainSceneDisplayLogic) {
        self.viewController = viewController
    }
}

extension MainScenePresenter: MainScenePresentationLogic {
    func presentContent(response: MainScene.Content.Response) {
        let viewModel = MainScene.Content.ViewModel(cards: response.cards)
        viewController?.displayContent(viewModel: viewModel)
    }
}
