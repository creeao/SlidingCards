//
//  SwipeableStackView.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

class SwipeableStackView: UIView {
    
    private enum Settings {
        enum AnimationDuration {
            static let setFrame: TimeInterval = 0.2
        }
        enum Inset {
            static let vertical: CGFloat = 12
            static let horizontal: CGFloat = 12
        }
        static let numberOfVisibleItems: Int = 3
    }
    
    // MARK: - Properties
    weak var delegate: SwipeableStackViewDelegate?
    weak var dataSource: SwipeableStackViewDataSource?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Methods
    func reloadData() {
        guard let dataSource = dataSource else { return }
        removeAllCardViews()

        let numberOfItems = dataSource.numberOfItems(in: self)
        remainingItemsCount = numberOfItems
        
        for index in 0..<min(numberOfItems, Settings.numberOfVisibleItems) {
            addItem(dataSource.swipeableStackView(self, forItemAt: index), at: index)
        }
    }
    
    func reloadNewData() {
        guard let dataSource = dataSource else { return }
        removeAllCardViews()

        let numberOfItems = dataSource.numberOfItems(in: self)
        remainingItemsCount = numberOfItems
        
        for index in 0..<min(numberOfItems, Settings.numberOfVisibleItems) {
            
            addItem(dataSource.swipeableStackView(self, forItemAt: index), at: index)
        }
    }
    
    // MARK: - Private Properties
    private var remainingItemsCount: Int = 0
    private var items: [SwipeableStackViewItem] = []
    private var visibleItems: [SwipeableStackViewItem] {
        return subviews as? [SwipeableStackViewItem] ?? []
    }
}

// MARK: - Private Methods
extension SwipeableStackView: SwipeableStackViewItemDelegate {
    
    func didSelect(item: SwipeableStackViewItem) {
        guard let itemIndex = items.firstIndex(of: item) else { return }
        delegate?.swipeableStackView(self, didSelectItemAt: itemIndex)
    }
    
    func didEndSwipe(onItem item: SwipeableStackViewItem) {
        guard let dataSource = dataSource else { return }
        item.removeFromSuperview()
        
        if remainingItemsCount > 0 {
            let newIndex = dataSource.numberOfItems(in: self) - remainingItemsCount
            addItem(dataSource.swipeableStackView(self, forItemAt: newIndex), at: Settings.numberOfVisibleItems - 1)
        }
        
        for (itemIndex, item) in visibleItems.reversed().enumerated() {
            UIView.animate(withDuration: Settings.AnimationDuration.setFrame, animations: {
                self.setFrame(for: item, at: itemIndex)
                self.layoutIfNeeded()
            })
        }
    }
}

// MARK: - Private Methods
private extension SwipeableStackView {
    
    func removeAllCardViews() {
        visibleItems.forEach { $0.removeFromSuperview() }
        items = []
    }
    
    func addItem(_ item: SwipeableStackViewItem, at index: Int) {
        item.delegate = self
        remainingItemsCount -= 1
        
        items.append(item)
        insertSubview(item, at: 0)
        setFrame(for: item, at: index)
    }
    
    func setFrame(for itemView: SwipeableStackViewItem, at index: Int) {
        var itemViewFrame = bounds
        let verticalInset = CGFloat(index) * Settings.Inset.vertical
        let horizontalInset = CGFloat(index) * Settings.Inset.horizontal
        
        itemViewFrame.size.width -= 2 * horizontalInset
        itemViewFrame.origin.x += horizontalInset
        itemViewFrame.origin.y += verticalInset
        
        itemView.frame = itemViewFrame
    }
}
