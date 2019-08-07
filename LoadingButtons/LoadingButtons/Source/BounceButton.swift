//
//  BounceButton.swift
//  LoadingButtons
//
//  Created by Ho, Tsung Wei on 8/6/19.
//  Copyright © 2019 Ho, Tsungwei. All rights reserved.
//

import UIKit

open class BounceButton: LoadingButton {
    public func setTextStyles(textColor: UIColor? = nil, font: UIFont? = nil) {
        self.setTitleColor(textColor, for: .normal)
        if let font = font {
            self.titleLabel?.font = font
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    }
    /**
     Show a loader inside the button, and enable or disable user interection while loading
     */
    open override func showLoader(userInteraction: Bool = false, _ completion: LBCallback = nil) {
        showLoader([self.titleLabel, self.imageView], userInteraction: userInteraction, completion)
    }
    
    private func showLoader(_ viewsToBeHide: [UIView?], userInteraction: Bool = false, _ completion: LBCallback = nil) {
        guard self.subviews.contains(indicator) == false else { return }
        
        self.indicator.radius = min(0.7 * self.frame.height/2, self.indicator.radius)
        isLoading = true
        self.isUserInteractionEnabled = userInteraction
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            viewsToBeHide.forEach {
                $0?.alpha = 0.0
            }
        }) { [weak self] (finished) in
            guard let self = self else { return }
            self.addSubview(self.indicator)
            self.indicator.startAnimating()
            completion?()
        }
    }
    /**
     Show a loader inside the button with image.
     */
    open func showLoaderWithImage(userInteraction: Bool = false){
        showLoader([self.titleLabel], userInteraction: userInteraction)
    }
    
    open override func hideLoader(_ completion: LBCallback){
        guard self.subviews.contains(indicator) else { return }
        isLoading = false
        self.isUserInteractionEnabled = true
        self.indicator.stopAnimating()
        self.indicator.removeFromSuperview()
        UIView.transition(with: self, duration: 0.2, options: .curveEaseIn, animations: {
            self.titleLabel?.alpha = 1.0
            self.imageView?.alpha = 1.0
        }) { _ in
            completion?()
        }
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if shadowAdded || !withShadow { return }
        shadowAdded = true
        
        shadowLayer = UIView(frame: self.frame)
        
        guard let shadowLayer = shadowLayer else { return }
        shadowLayer.setAsShadow(bounds: bounds, cornerRadius: self.cornerRadius)
        self.superview?.insertSubview(shadowLayer, belowSubview: self)
    }
    
    // MARK: Touch
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
}
