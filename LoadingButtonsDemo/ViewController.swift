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
        .lineScalePulse, .ballBeat
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
        btnLine.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        btnFill.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
    }
    
    private func initUI() {
        self.view.backgroundColor = .white
        navbar = addNavigationBar(title: "Loading Buttons")
        // Leave the frame to be zero since we will use stackView later to handle the layouts
        btnLine = LoadingButton(frame: .zero, text: "Line", textColor: .black, bgColor: .white)
        btnLine.setCornerBorder(color: .black, cornerRadius: 12.0, borderWidth: 1.5)
        btnFill = LoadingButton(frame: .zero, text: "Fill", textColor: .white, bgColor: .black)
        stackBtns = UIStackView(arrangedSubviews: [btnLine, btnFill])
        stackBtns.distribution = .fillEqually
        stackBtns.axis = .horizontal
        self.view.addSubViews([stackBtns])
        setupCollectionView()
    }
    
    @objc private func tapButton(_ sender: LoadingButton) {
        guard nil != selectedCell else { return }
        if sender.isLoading {
            sender.hideLoader()
        } else {
            sender.showLoader(userInteraction: true)
            delay(3.0) {
                sender.hideLoader()
            }
        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white
        collectionView.canCancelContentTouches = false
        if let layout = self.collectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
            collectionView.collectionViewLayout = layout
        }
        self.view.addSubViews([collectionView])
        (collectionView.dataSource, collectionView.delegate) = (self, self)
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
    // didHighlightItemAt
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let selectedCell = selectedCell {
            selectedCell.setCornerBorder()
        }
        if let cell = collectionView.cellForItem(at: indexPath), let type = (cell as? CollectionViewCell)?.type {
            selectedCell = cell
            DispatchQueue.main.async {
                cell.setCornerBorder(color: .black, borderWidth: 1.5)
            }
            // Reset buttons
            if btnLine.isLoading {
                btnLine.hideLoader()
            }
            if btnFill.isLoading {
                btnFill.hideLoader()
            }
            // Set up line indicator
            var lineIndicator = type.indicator
            lineIndicator.color = .darkGray
            btnLine.indicator = lineIndicator
            // Set up fill indicator
            var fillIndicator = type.indicator
            fillIndicator.color = .lightGray
            btnFill.indicator = fillIndicator
        }
    }
}
