//
//  SwipeableStackViewDataSource.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import Foundation

protocol SwipeableStackViewDataSource: class {
    func numberOfItems(in swipeableStackView: SwipeableStackView) -> Int
    func swipeableStackView(_ swipeableStackView: SwipeableStackView, forItemAt index: Int) -> SwipeableStackViewItem
}
