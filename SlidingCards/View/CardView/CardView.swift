//
//  CardView.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

class CardView: SwipeableStackViewItem {
    
    // MARK: Subviews
    
    private let text = UILabel()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: centerXAnchor),
            text.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupStyle() {
        backgroundColor = .white
        text.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        setCornerRadius()
        setShadow()
    }
    
    // MARK: Setup ViewModel
    
    func setViewModel(viewModel: CardViewModel) {
        text.text = "\(viewModel.text.uppercased()) \(viewModel.id)"
    }
}
