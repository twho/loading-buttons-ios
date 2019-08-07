//
//  MaterialButton.swift
//  MaterialDesignWidgets
//
//  Created by Le Van Nghia on 11/15/14.
//  Updated by Ho, Tsung Wei on 4/11/19.
//  Copyright © 2019 Michael T. Ho. All rights reserved.
//

import UIKit

open class MaterialButton: LoadingButton {
    
    @IBInspectable open var maskEnabled: Bool = true {
        didSet {
            rippleLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable open override var cornerRadius: CGFloat {
        didSet {
            rippleLayer.superLayerDidResize()
        }
    }
    @IBInspectable open var elevation: CGFloat = 0 {
        didSet {
            rippleLayer.elevation = elevation
        }
    }
    @IBInspectable open var shadowOffset: CGSize = CGSize.zero {
        didSet {
            rippleLayer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable open var roundingCorners: UIRectCorner = UIRectCorner.allCorners {
        didSet {
            rippleLayer.roundingCorners = roundingCorners
        }
    }
    @IBInspectable open var rippleEnabled: Bool = true {
        didSet {
            rippleLayer.rippleEnabled = rippleEnabled
        }
    }
    @IBInspectable open var rippleDuration: CFTimeInterval = 0.35 {
        didSet {
            rippleLayer.rippleDuration = rippleDuration
        }
    }
    @IBInspectable open var rippleScaleRatio: CGFloat = 1.0 {
        didSet {
            rippleLayer.rippleScaleRatio = rippleScaleRatio
        }
    }
    @IBInspectable open var rippleLayerColor: UIColor = .lightGray {
        didSet {
            rippleLayer.setRippleColor(color: rippleLayerColor)
        }
    }
    @IBInspectable open var rippleLayerAlpha: CGFloat = 0.3 {
        didSet {
            rippleLayer.setRippleColor(color: rippleLayerColor, withRippleAlpha: rippleLayerAlpha, withBackgroundAlpha: rippleLayerAlpha)
        }
    }
    @IBInspectable open var backgroundAnimationEnabled: Bool = true {
        didSet {
            rippleLayer.backgroundAnimationEnabled = backgroundAnimationEnabled
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            rippleLayer.superLayerDidResize()
        }
    }
    
    fileprivate lazy var rippleLayer: RippleLayer = RippleLayer(withView: self)
    
    // MARK: Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    /**
     Convenience init of theme button with required information
     
     - Parameter icon:      the icon of the button, it is be nil by default.
     - Parameter text:      the title of the button.
     - Parameter textColor: the text color of the button.
     - Parameter textSize:  the text size of the button label.
     - Parameter bgColor:   the background color of the button, tint color will be automatically generated.
     */
    public override init(
        frame: CGRect = .zero,
        icon: UIImage? = nil,
        text: String? = nil,
        textColor: UIColor? = .white,
        font: UIFont? = nil,
        bgColor: UIColor = .black,
        cornerRadius: CGFloat = 12.0,
        withShadow: Bool = false
    ) {
        super.init(
            frame: frame,
            icon: icon,
            text: text,
            textColor: textColor,
            font: font,
            bgColor: bgColor,
            cornerRadius: cornerRadius,
            withShadow: withShadow
        )
        setupLayer()
    }
    
    public func setTextStyles(textColor: UIColor? = nil, font: UIFont? = nil) {
        self.setTitleColor(textColor, for: .normal)
        if let font = font {
            self.titleLabel?.font = font
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayer()
    }
    
    // MARK: Setup
    fileprivate func setupLayer() {
        rippleLayer = RippleLayer(withView: self)
        rippleLayer.elevation = self.elevation
        self.layer.cornerRadius = self.cornerRadius
        rippleLayer.elevationOffset = self.shadowOffset
        rippleLayer.roundingCorners = self.roundingCorners
        rippleLayer.maskEnabled = self.maskEnabled
        rippleLayer.rippleScaleRatio = self.rippleScaleRatio
        rippleLayer.rippleDuration = self.rippleDuration
        rippleLayer.rippleEnabled = self.rippleEnabled
        rippleLayer.backgroundAnimationEnabled = self.backgroundAnimationEnabled
        rippleLayer.setRippleColor(color: self.rippleLayerColor)
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
        // Set up loading indicator
        indicator.radius = min(0.7*self.frame.height/2, indicator.radius)
        isLoading = true
        self.isUserInteractionEnabled = userInteraction
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            viewsToBeHide.forEach {
                $0?.alpha = 0.0
            }
        }) { [weak self] _ in
            guard let self = self else { return }
            self.addSubview(self.indicator)
            if self.isLoading {
                self.indicator.startAnimating()
            } else {
                self.hideLoader()
            }
            completion?()
        }
    }
    /**
     Show a loader inside the button with image.
     */
    open func showLoaderWithImage(userInteraction: Bool = false) {
        showLoader([self.titleLabel], userInteraction: userInteraction)
    }
    
    open override func hideLoader(_ completion: LBCallback = nil) {
        guard self.subviews.contains(indicator) else { return }
        isLoading = false
        self.isUserInteractionEnabled = true
        indicator.stopAnimating()
        indicator.removeFromSuperview()
        UIView.transition(with: self, duration: 0.2, options: .curveEaseIn, animations: {
            self.titleLabel?.alpha = 1.0
            self.imageView?.alpha = 1.0
        }) { _ in
            completion?()
        }
    }
    
    public func fillContent() {
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if shadowAdded || !withShadow { return }
        shadowAdded = true
        // Set up shadow layer
        shadowLayer = UIView(frame: self.frame)
        guard let shadowLayer = shadowLayer else { return }
        shadowLayer.setAsShadow(bounds: bounds, cornerRadius: self.cornerRadius)
        self.superview?.insertSubview(shadowLayer, belowSubview: self)
    }
    
    // MARK: Touch
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        rippleLayer.touchesBegan(touches: touches, withEvent: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        rippleLayer.touchesEnded(touches: touches, withEvent: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        rippleLayer.touchesCancelled(touches: touches, withEvent: event)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        rippleLayer.touchesMoved(touches: touches, withEvent: event)
    }
}
