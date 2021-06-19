//
//  MainSceneModels.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

enum MainScene {
    enum Content {
        struct Request {}
        
        struct Response {
            let cards: [CardViewModel]
        }
        
        struct ViewModel {
            let cards: [CardViewModel]
        }
    }
}
