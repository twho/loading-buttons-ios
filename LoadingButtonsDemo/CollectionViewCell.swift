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
    private var selectIcon: UIImageView!
    private var bgColor: UIColor = .clear
    override var isSelected: Bool {
        didSet {
            selectIcon.isHidden = !isSelected
            if #available(iOS 13.0, *) {
                title.textColor = isSelected ? .label : .tertiaryLabel
                // Reset the indicator
                indicator.stopAnimating()
                indicator.color = isSelected ? .label : .tertiaryLabel
                indicator.startAnimating()
            }
        }
    }
    // Package-protected properties
    var type: IndicatorType = .sysDefault

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setCornerBorder()
        initUI()
    }
    
    private func initUI() {
        title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 14.0)
        
        if #available(iOS 13.0, *) {
            selectIcon = UIImageView(image: #imageLiteral(resourceName: "ic_check").colored(.label))
            title.textColor = .tertiaryLabel
            indicator.color = .tertiaryLabel
        } else {
            selectIcon = UIImageView(image: #imageLiteral(resourceName: "ic_check").colored(.black))
        }
        selectIcon.isHidden = true
        selectIcon.contentMode = .scaleAspectFit
        self.addSubViews([indicator, title, selectIcon])
    }
    
    public func configure(_ type: IndicatorType) {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.type = type
        indicator = type.indicator
        initUI()
        title.text = type.rawValue
        self.layoutIfNeeded()
        indicator.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.05*self.frame.height).isActive = true
        indicator.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        indicator.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.1*self.frame.width).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.1*self.frame.width).isActive = true
        title.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 0.05*self.frame.height).isActive = true
        title.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1).isActive = true
        selectIcon.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0.05*self.frame.height).isActive = true
        selectIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        selectIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        selectIcon.widthAnchor.constraint(equalTo: selectIcon.heightAnchor).isActive = true
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
