//
//  SwipeableStackViewItem.swift
//  SlidingCards
//
//  Created by Eryk Chrustek on 19/06/2021.
//

import UIKit

class SwipeableStackViewItem: UIView {
    
     enum Settings {
        enum PanGesture {
            static let maxRotation: CGFloat = 1.0
            static let zRotationAngleDelta: CGFloat = .pi / 10
            static let zRotationAngleSpeed: CGFloat = 2.0
            static let minSwipePercentage: CGFloat = 0.5
        }
        enum CompletePanAnimation {
            static let duration: TimeInterval = 0.3
        }
        enum ResetAnimation {
            static let speed: CGFloat = 2.0
        }
    }
    
    // MARK: -  Properties
    weak var delegate: SwipeableStackViewItemDelegate?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
     func commonInit() {
        layer.rasterizationScale = UIScreen.main.scale

        setupTapGestureRecognizer()
        setupPanGestureRecognizer()
    }
    
    // MARK: -  Properties
     var panGestureTranslation: CGPoint = .zero
}

// MARK: - Gestures
 extension SwipeableStackViewItem {
    
    func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupPanGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        
    }
    
    @objc func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        panGestureTranslation = gestureRecognizer.translation(in: self)
        
        switch gestureRecognizer.state {
        case .began:
            removeAnimations()
            delegate?.didBeginSwipe(onItem: self)

            let initialTouchPoint = gestureRecognizer.location(in: self)
            let newAnchorPoint = CGPoint(x: initialTouchPoint.x / bounds.width, y: initialTouchPoint.y / bounds.height)
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            
            layer.position = layer.position - oldPosition + newPosition
            layer.anchorPoint = newAnchorPoint
            layer.shouldRasterize = true
            
        case .changed:
            let panGestureTe = Settings.PanGesture.self
            let rotationStrength = min(panGestureTranslation.x / frame.width, panGestureTe.maxRotation)
            let rotationAngle = panGestureTe.zRotationAngleSpeed * panGestureTe.zRotationAngleDelta * rotationStrength
            
            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, panGestureTranslation.x, panGestureTranslation.y, 0)
            layer.transform = transform
            
        case .ended:
            runCompletePanAnimation()
            layer.shouldRasterize = false
            
        default:
            runResetItemAnimation()
            layer.shouldRasterize = false
        }
    }
}

// MARK: - Animation Methods
 extension SwipeableStackViewItem {
    
    func runCompletePanAnimation() {
        guard let dragDirection = dragDirection, dragPercentage >= Settings.PanGesture.minSwipePercentage else {
            runResetItemAnimation()
            return
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.delegate?.didEndSwipe(onItem: self)
        }
        
        let newPosition = layer.position + animationPointForDirection(dragDirection)
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.duration = Settings.CompletePanAnimation.duration
        positionAnimation.fromValue = layer.position
        positionAnimation.toValue = newPosition
        
        layer.position = newPosition
        layer.add(positionAnimation, forKey: nil)
        
        CATransaction.commit()
    }
 
     func runResetItemAnimation() {
        let newTransform = CATransform3DIdentity
        let transformAnimation = CASpringAnimation(keyPath: "transform")
        transformAnimation.duration = transformAnimation.settlingDuration
        transformAnimation.fromValue = layer.transform
        transformAnimation.toValue = newTransform
        transformAnimation.speed = Float(Settings.ResetAnimation.speed)
        
        layer.transform = newTransform
        layer.add(transformAnimation, forKey: nil)
    }
    
    func removeAnimations() {
        layer.removeAllAnimations()
    }
}

// MARK: - Helper Methods
 extension SwipeableStackViewItem {
    
     var dragDirection: SwipeDirection? {
        let normalizedDragPoint = panGestureTranslation.normalizedDistance(for: bounds.size)
        return SwipeDirection.allDirections
            .reduce((distance: CGFloat.infinity, direction: nil), { closest, direction -> (CGFloat, SwipeDirection?) in
                let distance = direction.point.distance(to: normalizedDragPoint)
                if distance < closest.distance {
                   return (distance, direction)
                }
                return closest
            })
            .direction
    }
    
     var dragPercentage: CGFloat {
        guard let dragDirection = dragDirection else { return 0.0 }
        let normalizedDragPoint = panGestureTranslation.normalizedDistance(for: frame.size)
        let swipePoint = normalizedDragPoint.scalarProjectionPoint(with: dragDirection.point)
        let rect = SwipeDirection.boundsRect
        
        guard rect.contains(swipePoint) else { return 1.0 }
        let centerDistance = swipePoint.distance(to: .zero)
        let targetLine: (CGPoint, CGPoint) = (swipePoint, .zero)
        
        return rect.perimeterLines
            .compactMap { CGPoint.intersectionBetweenLines(targetLine, line2: $0) }
            .map { centerDistance / $0.distance(to: .zero) }
            .min() ?? 0.0
        
    }
    
    func animationPointForDirection(_ direction: SwipeDirection) -> CGPoint {
        let point = direction.point
        return point.screenPointForSize(UIScreen.main.bounds.size)
    }
}
