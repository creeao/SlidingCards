//
//  SceneFactory.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

protocol SceneFactory {
    var configurator: MainSceneConfigurator! { get set }
    func makeLoginScene() -> UIViewController
}

final class DefaultSceneFactory: SceneFactory {
    var configurator: MainSceneConfigurator!
    
    func makeLoginScene() -> UIViewController {
        let viewController = MainSceneViewController()
        return configurator.configured(viewController)
    }
}
