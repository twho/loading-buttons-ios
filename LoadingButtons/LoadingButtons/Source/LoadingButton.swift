//
//  LoadingButton.swift
//  LoadingButtons
//
//  Created by Ho, Tsung Wei on 8/7/19.
//  Copyright © 2019 Ho, Tsungwei. All rights reserved.
//

import UIKit

open class LoadingButton: UIButton {
    public var shadowAdded: Bool = false
    public var withShadow: Bool = false
    public var isLoading: Bool = false
    // MARK: - Package-protected variables
    var indicator: UIView & IndicatorProtocol = MaterialLoadingIndicator()
    open var cornerRadius: CGFloat = 12.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    var shadowLayer: UIView?
    /**
     Get all views in the button. Views include the button itself and the shadow.
     */
    var entireViewGroup: [UIView] {
        var views: [UIView] = [self]
        if let shadow = self.shadowLayer {
            views.append(shadow)
        }
        return views
    }
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
        
        if bgColor == self.indicator.color {
            self.indicator.color = .white
        }
        
        self.backgroundColor = bgColor
        self.setBackgroundImage(UIImage(.lightGray), for: .disabled)
        self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.setCornerBorder(cornerRadius: cornerRadius)
        self.withShadow = withShadow
        self.cornerRadius = cornerRadius
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func showLoader(userInteraction: Bool, _ completion: LBCallback) {
        
    }
    
    open func hideLoader(_ completion: LBCallback) {
        
    }
}
