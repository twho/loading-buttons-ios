//
//  ViewController.swift
//  LoadingButtonsDemo
//
//  Created by Ho, Tsung Wei on 8/8/19.
//  Copyright © 2019 Michael Ho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - UI widgets
    private var navbar: UINavigationBar!
    private var collectionView: UICollectionView!
    private var stackBtns: UIStackView!
    private var btnLine: LoadingButton!
    private var btnFill: LoadingButton!
    private var segmentedControl: UISegmentedControl!
    // MARK: - Private properties
    private var cellId = "LBCollectionViewCell"
    private var indicators: [IndicatorType] = [
        .sysDefault, .material, .ballPulse,
        .ballPulseSync, .ballSpinFade, .lineScale,
        .lineScalePulse, .ballBeat, .lineSpin
    ]
    private var selectedCell: UICollectionViewCell?
    // MARK: - Package-protected properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        navbar = addNavigationBar(title: "Loading Buttons")
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .secondarySystemBackground
            btnLine = LoadingButton(text: "Line", buttonStyle: .outline)
            btnFill = LoadingButton(text: "Fill", buttonStyle: .fill)
        } else {
            self.view.backgroundColor = .white
            btnLine = LoadingButton(text: "Line", textColor: .black, bgColor: .white)
            btnLine.setCornerBorder(color: .black, cornerRadius: 12.0, borderWidth: 1.5)
            btnFill = LoadingButton(text: "Fill", textColor: .white, bgColor: .black)
        }
        btnLine.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        btnFill.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        stackBtns = UIStackView(arrangedSubviews: [btnLine, btnFill])
        stackBtns.distribution = .fillEqually
        stackBtns.axis = .horizontal
        self.view.addSubViews([stackBtns])
        setupCollectionView()
    }
    
    @objc private func tapButton(_ sender: LoadingButton) {
        guard nil != selectedCell else { return }
        sender.isLoading ? sender.hideLoader() : sender.showLoader(userInteraction: true)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .white
        collectionView.canCancelContentTouches = false
        if let layout = self.collectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
            collectionView.collectionViewLayout = layout
        }
        self.view.addSubViews([collectionView])
        (collectionView.dataSource, collectionView.delegate) = (self, self)
        self.collectionView.backgroundColor = .clear
    }
    /**
     traitCollectionDidChange is called when user switch between dark and light mode. Whenever this is \
     called, reset the UI.
     */
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.view.subviews.forEach { $0.removeFromSuperview() }
        initUI()
    }
    // viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Select an initial loading indicator
        collectionView(self.collectionView, didSelectItemAt: IndexPath(item: 1, section: 1))
    }
    // viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let dim = self.view.frame.size
        collectionView.setAnchors(left: self.view, lConst: 0.05*dim.width, right: self.view, rConst: -0.05*dim.width)
        collectionView.topAnchor.constraint(equalTo: navbar.bottomAnchor, constant: 0.02*dim.height).isActive = true
        stackBtns.spacing = 0.05*dim.width
        stackBtns.setAnchors(
            bottom: self.view, bConst: -0.05*dim.height,
            left: self.view, lConst: 0.05*dim.width,
            right: self.view, rConst: -0.05*dim.width
        )
        stackBtns.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0.05*dim.height).isActive = true
        stackBtns.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        self.view.layoutIfNeeded()
    }
}
// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        guard
            let collectionCell = cell as? CollectionViewCell,
            indexPath.section*3 + indexPath.item < indicators.count
        else {
            return cell
        }
        collectionCell.configure(indicators[indexPath.section*3 + indexPath.item])
        return collectionCell
    }
    // collectionViewLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height/3)
    }
    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell = selectedCell {
            selectedCell.setCornerBorder()
        }
        if let cell = collectionView.cellForItem(at: indexPath), let type = (cell as? CollectionViewCell)?.type {
            selectedCell = cell
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    cell.setCornerBorder(color: .label, borderWidth: 1.5)
                } else {
                    cell.setCornerBorder(color: .black, borderWidth: 1.5)
                }
            }
            // Reset buttons
            if btnLine.isLoading {
                btnLine.hideLoader()
            }
            if btnFill.isLoading {
                btnFill.hideLoader()
            }
            // Set up line indicator
            let lineIndicator = type.indicator
            btnLine.indicator = lineIndicator
            
            // Set up fill indicator
            let fillIndicator = type.indicator
            btnFill.indicator = fillIndicator
            
            // Set colors for dark/light mode
            if #available(iOS 13.0, *) {
                btnLine.indicator.color = .label
                btnFill.indicator.color = .label
            } else {
                btnLine.indicator.color = .darkGray
                btnFill.indicator.color = .lightGray
            }
        }
    }
}
