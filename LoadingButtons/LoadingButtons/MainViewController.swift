//
//  MainViewController.swift
//  LoadingButtons
//
//  Created by Ho, Tsung Wei on 8/4/19.
//  Copyright © 2019 Ho, Tsungwei. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private var btn: MaterialButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        btn.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    
    private func initUI() {
        self.view.backgroundColor = .white
        btn = MaterialButton(text: "Hey", textColor: .white, bgColor: .black, cornerRadius: 12.0)
        self.view.addSubViews([btn])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btn.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        btn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.view.centerSubView(btn)
    }
    
    @objc func tapButton() {
        btn.showLoader()
    }
}

