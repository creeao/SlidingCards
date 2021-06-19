//
//  MainSceneContracts.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

// MARK: - Interactor

protocol MainSceneBusinessLogic: AnyObject {
    var presenter: MainScenePresenting? { get }
    func prepareContent(request: MainScene.Content.Request)
}

protocol MainSceneDataStore: class {}

// MARK: - Presenter

typealias MainScenePresenting = MainScenePresentationLogic & MainScenePresentationSetup

protocol MainScenePresentationLogic {
    func presentContent(response: MainScene.Content.Response)
}

protocol MainScenePresentationSetup {
    func attach(viewController: MainSceneDisplayLogic)
}

// MARK: - View Controller

protocol MainSceneDisplayLogic: class {
    func displayContent(viewModel: MainScene.Content.ViewModel)
}
