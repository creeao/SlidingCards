//
//  SwipeableStackViewItemDelegate.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import Foundation

protocol SwipeableStackViewItemDelegate: class {
    func didSelect(item: SwipeableStackViewItem)
    func didBeginSwipe(onItem item: SwipeableStackViewItem)
    func didEndSwipe(onItem item: SwipeableStackViewItem)
}

// MARK: - Default Implementation
extension SwipeableStackViewItemDelegate {
    func didTap(item: SwipeableStackViewItem) {}
    
    func didBeginSwipe(onItem item: SwipeableStackViewItem) {}
    
    func didEndSwipe(onItem item: SwipeableStackViewItem) {}
}
