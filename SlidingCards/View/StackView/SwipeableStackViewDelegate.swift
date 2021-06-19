//
//  SwipeableStackViewDelegate.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

protocol SwipeableStackViewDelegate: class {
    func swipeableStackView(_ swipeableStackView: SwipeableStackView, didSelectItemAt index: Int)
}

// MARK: - Default Implementation
extension SwipeableStackViewDelegate {
    func swipeableStackView(_ swipeableStackView: SwipeableStackView, didSelectItemAt index: Int) {}
}
