//
//  MaterialButton.swift
//  MaterialDesignWidgets
//
//  Created by Le Van Nghia on 11/15/14.
//  Updated by Ho, Tsung Wei on 4/11/19.
//  Copyright © 2019 Michael T. Ho. All rights reserved.
//

import UIKit

open class MaterialButton: UIButton {
    @IBInspectable open var maskEnabled: Bool = true {
        didSet {
            rippleLayer.maskEnabled = maskEnabled
        }
    }
    @IBInspectable open var cornerRadius: CGFloat = 12.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
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
    
    public var shadowAdded: Bool = false
    public var withShadow: Bool = false
    var shadowLayer: UIView?
    
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
    
    public func getEntireView() -> [UIView] {
        var views: [UIView] = [self]
        if let shadow = self.shadowLayer {
            views.append(shadow)
        }
        return views
    }
    
    /**
     Convenience init of theme button with required information
     
     - Parameter icon:      the icon of the button, it is be nil by default.
     - Parameter text:      the title of the button.
     - Parameter textColor: the text color of the button.
     - Parameter textSize:  the text size of the button label.
     - Parameter bgColor:   the background color of the button, tint color will be automatically generated.
     */
    public convenience init(icon: UIImage? = nil, text: String? = nil, textColor: UIColor? = .white, font: UIFont? = nil, bgColor: UIColor = .black, cornerRadius: CGFloat = 12.0, withShadow: Bool = false) {
        self.init()
        
        self.rippleLayerColor = bgColor.getColorTint()
        if let icon = icon {
            self.setImage(icon)
        }
        
        if let text = text {
            self.setTitle(text)
            self.setTitleColor(textColor, for: .normal)
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        if let font = font {
            self.titleLabel?.font = font
        }
        
        if bgColor == self.indicator.color {
            self.indicator.color = .white
        }
        
        self.backgroundColor = bgColor
        self.setBackgroundImage(UIImage(color: .lightGray), for: .disabled)
        self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.setCornerBorder(cornerRadius: cornerRadius)
        self.withShadow = withShadow
        self.cornerRadius = cornerRadius
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
    
    // MARK: - Loading, refer to pmusolino/PMSuperButton on Github
    
    let indicator = MaterialLoadingIndicator()
    public var isLoading: Bool = false
    
    /**
     Show a loader inside the button, and enable or disable user interection while loading
     */
    open func showLoader(userInteraction: Bool = false, completion: BtnAction = nil) {
        showLoader(viewsToBeHide: [self.titleLabel, self.imageView], userInteraction: userInteraction, completion: completion)
    }
    
    private func showLoader(viewsToBeHide: [UIView?], userInteraction: Bool = false, completion: BtnAction = nil) {
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
    open func showLoaderWithImage(userInteraction: Bool = false){
        showLoader(viewsToBeHide: [self.titleLabel], userInteraction: userInteraction)
    }
    
    open func hideLoader(){
        guard self.subviews.contains(indicator) == true else { return }
        
        isLoading = false
        self.isUserInteractionEnabled = true
        self.indicator.stopAnimating()
        self.indicator.removeFromSuperview()
        UIView.transition(with: self, duration: 0.2, options: .curveEaseIn, animations: {
            self.titleLabel?.alpha = 1.0
            self.imageView?.alpha = 1.0
        }) { (finished) in
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
