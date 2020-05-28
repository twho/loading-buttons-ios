//
//  File.swift
//  LoadingButtonsDemo
//
//  Created by Ho, Tsung Wei on 8/12/19.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func addNavigationBar(title: String) -> UINavigationBar {
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: 50.0))
        navbar.barStyle = .black
        navbar.tintColor = .white
        navbar.backgroundColor = .black
        navbar.isTranslucent = false
        
        let navItem = UINavigationItem()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20.0)
        titleLabel.adjustsFontSizeToFitWidth = true
        navItem.titleView = titleLabel
        navbar.items = [navItem]
        
        let view = UIView()
        view.backgroundColor = .black
        // Navigation is well defined, no need to set translating auto mask
        self.view.addSubview(navbar)
        self.view.addSubViews([view])
        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: navbar.bottomAnchor, constant: -navbar.frame.height).isActive = true
        view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        return navbar
    }
}

extension UIView {
    /**
     Set the anchors of current view. Make it align to the anchors of other views.
     
     - Parameter top:    The view as a reference for top anchor.
     - Parameter bottom: The view as a reference for bottom anchor.
     - Parameter left:   The view as a reference for left anchor.
     - Parameter right:  The view as a reference for right anchor.
     */
    public func setAnchors(
        top: UIView? = nil, tConst: CGFloat = 0.0,
        bottom: UIView? = nil, bConst: CGFloat = 0.0,
        left: UIView? = nil, lConst: CGFloat = 0.0,
        right: UIView? = nil, rConst: CGFloat = 0.0
    ) {
        // Align top anchor
        if let top = top {
            self.topAnchor.constraint(equalTo: top.topAnchor, constant: tConst).isActive = true
        }
        // Align bottom anchor
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom.bottomAnchor, constant: bConst).isActive = true
        }
        // Align left anchor
        if let left = left {
            self.leftAnchor.constraint(equalTo: left.leftAnchor, constant: lConst).isActive = true
        }
        // Align right anchor
        if let right = right {
            self.rightAnchor.constraint(equalTo: right.rightAnchor, constant: rConst).isActive = true
        }
    }
}

extension UIImage {
    /**
     Change the color of the image.
     
     - Parameter color: The color to be set to the UIImage.
     
     Returns an UIImage with specified color
     */
    public func colored(_ color: UIColor?) -> UIImage? {
        if let newColor = color {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            // Get current graphics context.
            let context = UIGraphicsGetCurrentContext()!
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.setBlendMode(.normal)
            // Fill the CGRect with the color specified.
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            context.clip(to: rect, mask: cgImage!)
            newColor.setFill()
            context.fill(rect)
            // Get the new image.
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            newImage.accessibilityIdentifier = accessibilityIdentifier
            return newImage
        }
        return self
    }
}
