//
//  MainSceneConfigurator.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import Foundation

protocol MainSceneConfigurator {
    func configured(_ viewController: MainSceneViewController) -> MainSceneViewController
}

final class DefaultMainSceneConfigurator: MainSceneConfigurator {

    private var sceneFactory: SceneFactory
    
    init(sceneFactory: SceneFactory) {
        self.sceneFactory = sceneFactory
    }
    
    @discardableResult
    func configured(_ viewController: MainSceneViewController) -> MainSceneViewController {
        sceneFactory.configurator = self
        let presenter = MainScenePresenter()
        let interactor = MainSceneInteractor()

        presenter.viewController = viewController
        interactor.presenter = presenter
        viewController.interactor = interactor
        return viewController
    }
}
