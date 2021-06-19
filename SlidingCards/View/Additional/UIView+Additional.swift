//
//  UIView+Additional.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

public extension UIView {
    func embedView(_ viewToEmbed: UIView) {
        addSubview(viewToEmbed)
        addConstraints(for: viewToEmbed)
    }
    
    func addConstraints(for embeddedView: UIView) {
        guard embeddedView.superview == self else { return }
        embeddedView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": embeddedView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .directionLeadingToTrailing, metrics: nil, views: ["view": embeddedView]))
    }
}
