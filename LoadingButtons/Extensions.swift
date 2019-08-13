//
//  Extensions.swift
//  LoadingButtons
//
//  Created by Ho, Tsung Wei on 8/6/19.
//  Copyright © 2019 Ho, Tsungwei. All rights reserved.
//

import UIKit

public typealias LBCallback = (() -> Void)?

// MARK: - Global functions
func delay(_ delay: Double, block: @escaping () -> (Void)) {
    DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + delay), execute: block)
}
// MARK: - UIColor
extension UIColor {
    /**
     Convert RGB value to CMYK value.
     
     - Parameter red: The red value of RGB.
     - Parameter green: The green value of RGB.
     - Parameter blue: The blue value of RGB.
     
     Returns a 4-tuple that represents the CMYK value converted from input RGB.
     */
    public func RGBtoCMYK(
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat
    ) -> (
        cyan: CGFloat,
        magenta: CGFloat,
        yellow: CGFloat,
        key: CGFloat
    ) {
        // Base case
        if red == 0, green == 0, blue == 0 {
            return (0, 0, 0, 1)
        }
        var cyan = 1 - red
        var magenta = 1 - green
        var yellow = 1 - blue
        let minCMY = min(cyan, magenta, yellow)
        cyan = (cyan - minCMY) / (1 - minCMY)
        magenta = (magenta - minCMY) / (1 - minCMY)
        yellow = (yellow - minCMY) / (1 - minCMY)
        return (cyan, magenta, yellow, minCMY)
    }
    /**
     Convert CMYK value to RGB value.
     
     - Parameter cyan: The cyan value of CMYK.
     - Parameter magenta: The magenta value of CMYK.
     - Parameter yellow: The yellow value of CMYK.
     - Parameter key: The key/black value of CMYK.
     
     Returns a 3-tuple that represents the RGB value converted from input CMYK.
     */
    public func CMYKtoRGB(
        cyan: CGFloat,
        magenta: CGFloat,
        yellow: CGFloat,
        key: CGFloat
    ) -> (
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat
    ) {
        let red = (1 - cyan) * (1 - key)
        let green = (1 - magenta) * (1 - key)
        let blue = (1 - yellow) * (1 - key)
        return (red, green, blue)
    }
    /**
     Get the tint color of the current color.
     */
    public func getColorTint() -> UIColor {
        let ciColor = CIColor(color: self)
        let originCMYK = RGBtoCMYK(red: ciColor.red, green: ciColor.green, blue: ciColor.blue)
        let kVal = originCMYK.key > 0.3 ? originCMYK.key - 0.2 : originCMYK.key + 0.2
        let tintRGB = CMYKtoRGB(cyan: originCMYK.cyan, magenta: originCMYK.magenta, yellow: originCMYK.yellow, key: kVal)
        return UIColor(red: tintRGB.red, green: tintRGB.green, blue: tintRGB.blue, alpha: 1.0)
    }
}
// MARK: - UIButton
extension UIButton {
    /**
     Set button image for all button states
     
     - Parameter image: The image to be set to the button.
     */
    open func setImage(_ image: UIImage?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setImage(image, for: state)
        }
    }
    /**
     Set button title for all button states
     
     - Parameter text: The text to be set to the button title.
     */
    open func setTitle(_ text: String?) {
        for state : UIControl.State in [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved] {
            self.setTitle(text, for: state)
        }
    }
}
// MARK: - UIImage
extension UIImage {
    /**
     Create color rectangle as image.
     
     - Parameter color: The color to be created as an UIImage
     - Parameter size:  The size of the UIImage, no need to be set when creating
     */
    public convenience init?(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil}
        self.init(cgImage: cgImage)
    }
}
// MARK: UIView
extension UIView {
    /**
     Set the corner radius of the view.
     
     - Parameter color:        The color of the border.
     - Parameter cornerRadius: The radius of the rounded corner.
     - Parameter borderWidth:  The width of the border.
     */
    open func setCornerBorder(color: UIColor? = nil, cornerRadius: CGFloat = 15.0, borderWidth: CGFloat = 1.5) {
        self.layer.borderColor = color != nil ? color!.cgColor : UIColor.clear.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    /**
     Set the shadow layer of the view.
     
     - Parameter bounds:       The bounds in CGRect of the shadow.
     - Parameter cornerRadius: The radius of the shadow path.
     - Parameter shadowRadius: The radius of the shadow.
     */
    open func setAsShadow(bounds: CGRect, cornerRadius: CGFloat = 0.0, shadowRadius: CGFloat = 1) {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = shadowRadius
        self.layer.masksToBounds = true
        self.clipsToBounds = false
    }
    /**
     Add subviews and make it prepared for AutoLayout.
     
     - Parameter views: The views to be added as subviews of current view.
     */
    public func addSubViews(_ views: [UIView]) {
        views.forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    /**
     Make the specified view (in parameter) to be centered of current view.
     
     - Parameter view: The view to be positioned to the center of current view.
     */
    public func centerSubView(_ view: UIView) {
        self.addConstraints(
            [
                NSLayoutConstraint(item: view, attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .centerX,
                                   multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .centerY,
                                   multiplier: 1.0, constant: 0.0)
            ]
        )
    }
}
