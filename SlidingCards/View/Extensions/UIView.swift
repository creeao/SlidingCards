//
//  UIView.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

extension UIView {
    func setCornerRadius() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
    }
    
    func setShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.1
    }
}
