//
//  MaterialLoadingIndicator.swift
//  MaterialDesignWidgets
//
//  Created by Le Van Nghia on 11/15/14.
//  Updated by Ho, Tsung Wei on 4/11/19.
//  Copyright © 2019 Michael T. Ho. All rights reserved.
//

import UIKit

open class MaterialLoadingIndicator: UIView {
    
    fileprivate let drawableLayer = CAShapeLayer()
    fileprivate var animating = false
    
    @IBInspectable open var color: UIColor = .lightGray {
        didSet {
            drawableLayer.strokeColor = self.color.cgColor
        }
    }
    
    @IBInspectable open var lineWidth: CGFloat = 3 {
        didSet {
            drawableLayer.lineWidth = self.lineWidth
            self.updatePath()
        }
    }
    
    open override var bounds: CGRect {
        didSet {
            updateFrame()
            updatePath()
        }
    }
    
    open var radius: CGFloat = 18.0
    
    public convenience init(radius: CGFloat = 18.0, color: UIColor = .gray) {
        self.init()
        self.radius = radius
        self.color = color
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
        updatePath()
    }
    
    open func startAnimating() {
        if self.animating {
            return
        }
        
        self.animating = true
        self.isHidden = false
        self.resetAnimations()
    }
    
    open func stopAnimating() {
        self.drawableLayer.removeAllAnimations()
        self.animating = false
        self.isHidden = true
    }
    
    fileprivate func setup() {
        self.isHidden = true
        self.layer.addSublayer(self.drawableLayer)
        self.drawableLayer.strokeColor = self.color.cgColor
        self.drawableLayer.lineWidth = self.lineWidth
        self.drawableLayer.fillColor = UIColor.clear.cgColor
        self.drawableLayer.lineJoin = CAShapeLayerLineJoin.round
        self.drawableLayer.strokeStart = 0.99
        self.drawableLayer.strokeEnd = 1
        updateFrame()
        updatePath()
    }
    
    fileprivate func updateFrame() {
        self.drawableLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    fileprivate func updatePath() {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius: CGFloat = self.radius - self.lineWidth
        
        self.drawableLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2 * Double.pi),
            clockwise: true)
            .cgPath
    }
    
    fileprivate func resetAnimations() {
        drawableLayer.removeAllAnimations()
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnim.fromValue = 0
        rotationAnim.duration = 4
        rotationAnim.toValue = 2 * Double.pi
        rotationAnim.repeatCount = Float.infinity
        rotationAnim.isRemovedOnCompletion = false
        
        let startHeadAnim = CABasicAnimation(keyPath: "strokeStart")
        startHeadAnim.beginTime = 0.1
        startHeadAnim.fromValue = 0
        startHeadAnim.toValue = 0.25
        startHeadAnim.duration = 1
        startHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let startTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        startTailAnim.beginTime = 0.1
        startTailAnim.fromValue = 0
        startTailAnim.toValue = 1
        startTailAnim.duration = 1
        startTailAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let endHeadAnim = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnim.beginTime = 1
        endHeadAnim.fromValue = 0.25
        endHeadAnim.toValue = 0.99
        endHeadAnim.duration = 0.5
        endHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let endTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnim.beginTime = 1
        endTailAnim.fromValue = 1
        endTailAnim.toValue = 1
        endTailAnim.duration = 0.5
        endTailAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let strokeAnimGroup = CAAnimationGroup()
        strokeAnimGroup.duration = 1.5
        strokeAnimGroup.animations = [startHeadAnim, startTailAnim, endHeadAnim, endTailAnim]
        strokeAnimGroup.repeatCount = Float.infinity
        strokeAnimGroup.isRemovedOnCompletion = false
        
        self.drawableLayer.add(rotationAnim, forKey: "rotation")
        self.drawableLayer.add(strokeAnimGroup, forKey: "stroke")
    }
}
