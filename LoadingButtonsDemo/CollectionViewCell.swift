//
//  CollectionViewCell.swift
//  LoadingButtonsDemo
//
//  Created by Ho, Tsung Wei on 8/9/19.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    // MARK: - UI widgets
    private var indicator: UIView & IndicatorProtocol = UIActivityIndicatorView()
    private var title: UILabel!
    private var bgColor: UIColor = .clear
    // Package-protected properties
    var type: IndicatorType = .sysDefault

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setCornerBorder()
        createTitle()
        self.addSubViews([indicator, title])
    }
    
    private func createTitle() {
        title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14.0)
    }
    
    public func configure(_ type: IndicatorType) {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.type = type
        indicator = type.indicator
        createTitle()
        title.text = type.rawValue
        self.addSubViews([indicator, title])
        self.layoutIfNeeded()
        indicator.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.1*self.frame.width).isActive = true
        indicator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.1*self.frame.width).isActive = true
        indicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.1*self.frame.height).isActive = true
        indicator.heightAnchor.constraint(equalTo: self.widthAnchor, constant: 0.1*self.frame.width).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.1*self.frame.width).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.1*self.frame.width).isActive = true
        title.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 0.1*self.frame.height).isActive = true
        self.layoutIfNeeded()
    }
    // Required init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.backgroundColor = self.bgColor == UIColor.clear ? .lightGray : self.bgColor.getColorTint()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.backgroundColor = self.bgColor
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.backgroundColor = self.bgColor
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.backgroundColor = self.bgColor == UIColor.clear ? .lightGray : self.bgColor.getColorTint()
    }
}
