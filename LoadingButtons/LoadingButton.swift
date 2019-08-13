//
//  LoadingButton.swift
//  LoadingButtons
//
//  Created by Ho, Tsung Wei on 8/7/19.
//  Copyright © 2019 Ho, Tsungwei. All rights reserved.
//

import UIKit

open class LoadingButton: UIButton {
    // MARK: - Public variables
    /**
     Current loading state.
     */
    public var isLoading: Bool = false
    /**
     The flag that indicate if the shadow is added to prevent duplicate drawing.
     */
    public var shadowAdded: Bool = false
    // MARK: - Package-protected variables
    /**
     The loading indicator used with the button.
     */
    open var indicator: UIView & IndicatorProtocol = UIActivityIndicatorView()
    /**
     Set to true to add shadow to the button.
     */
    open var withShadow: Bool = false
    open var cornerRadius: CGFloat = 12.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    open var shadowLayer: UIView?
    /**
     Get all views in the button. Views include the button itself and the shadow.
     */
    open var entireViewGroup: [UIView] {
        var views: [UIView] = [self]
        if let shadow = self.shadowLayer {
            views.append(shadow)
        }
        return views
    }
    // Private properties
    private(set) var bgColor: UIColor = .lightGray
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /**
     Convenience init of theme button with required information
     
     - Parameter icon:      the icon of the button, it is be nil by default.
     - Parameter text:      the title of the button.
     - Parameter textColor: the text color of the button.
     - Parameter textSize:  the text size of the button label.
     - Parameter bgColor:   the background color of the button, tint color will be automatically generated.
     */
    public init(
        frame: CGRect = .zero,
        icon: UIImage? = nil,
        text: String? = nil,
        textColor: UIColor? = .white,
        font: UIFont? = nil,
        bgColor: UIColor = .black,
        cornerRadius: CGFloat = 12.0,
        withShadow: Bool = false
    ) {
        super.init(frame: frame)
        
        if let icon = icon {
            self.setImage(icon)
        }
        
        if let text = text {
            self.setTitle(text)
            self.setTitleColor(textColor, for: .normal)
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        self.titleLabel?.font = font
        self.bgColor = bgColor
        self.backgroundColor = bgColor
        self.setBackgroundImage(UIImage(.lightGray), for: .disabled)
        self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.setCornerBorder(cornerRadius: cornerRadius)
        self.withShadow = withShadow
        self.cornerRadius = cornerRadius
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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func showLoader(userInteraction: Bool, _ completion: LBCallback = nil) {
        showLoader([titleLabel, imageView], userInteraction: userInteraction, completion)
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
                self.hideLoader(completion)
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
    
    open func hideLoader(_ completion: LBCallback = nil) {
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    }
    // MARK: Touch
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.backgroundColor = self.bgColor.getColorTint()
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.backgroundColor = self.bgColor
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.backgroundColor = self.bgColor
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.backgroundColor = self.bgColor.getColorTint()
    }
}
// MARK: - UIActivityIndicatorView
extension UIActivityIndicatorView: IndicatorProtocol {
    public var radius: CGFloat {
        get {
            return self.frame.width/2
        }
        set {
            self.frame.size = CGSize(width: 2*radius, height: 2*radius)
            self.setNeedsDisplay()
        }
    }
    
    public var color: UIColor {
        get {
            return self.tintColor
        }
        set {
            let ciColor = CIColor(color: newValue)
            self.style = newValue.RGBtoCMYK(red: ciColor.red, green: ciColor.green, blue: ciColor.blue).key > 0.5 ? .gray : .white
            self.tintColor = newValue
        }
    }
    // unused
    public func setupAnimation(in layer: CALayer, size: CGSize) {}
}
