//
//  MainSceneViewController.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

final class MainSceneViewController: UIViewController {
    
    // MARK: Properties
    
    var interactor: MainSceneBusinessLogic?
    
    // MARK: Subviews
    
    private var swipeableStackView = SwipeableStackView()
    private var cards = [CardViewModel]()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        prepareContent()
    }

    // MARK: Setup
    
    private func setup() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .white
        swipeableStackView.dataSource = self
        
        view.addSubview(swipeableStackView)
        swipeableStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            swipeableStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swipeableStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            swipeableStackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            swipeableStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9)
        ])
    }
    
    // MARK: Private methods
    
    private func prepareContent() {
        let request = MainScene.Content.Request()
        interactor?.prepareContent(request: request)
    }
}

extension MainSceneViewController: MainSceneDisplayLogic {
    func displayContent(viewModel: MainScene.Content.ViewModel) {
        DispatchQueue.main.async {
            self.cards = viewModel.cards
            self.swipeableStackView.reloadData()
        }
    }
}

extension MainSceneViewController: SwipeableStackViewDataSource {
    func numberOfItems(in swipeableStackView: SwipeableStackView) -> Int {
        cards.count
    }
    
    func swipeableStackView(_ swipeableStackView: SwipeableStackView, forItemAt index: Int) -> SwipeableStackViewItem {
        let profileViewItem = CardView()

        profileViewItem.setViewModel(viewModel: cards[index])
        return profileViewItem
    }
}
