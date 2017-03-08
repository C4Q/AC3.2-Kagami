//
//  SelectionViewController.swift
//  Kagami
//
//  Created by Eric Chang on 3/1/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import SnapKit


/**
 * !! DEPRECIATED NOT IN USE !!
 * !! DEPRECIATED NOT IN USE !!
 * !! DEPRECIATED NOT IN USE !!
 */
class SelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let testArray = ["Watch-50", "Partly Cloudy Day-50", "Appointment Reminders-50", "Quote-50", "News-50", "Push Notifications-50"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = ColorPalette.accentColor
        self.navigationController?.navigationBar.tintColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        setupCollectionView()
    }
    
    func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (view) in
            view.left.right.bottom.equalToSuperview()
            view.top.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCollectionViewCell.identifier, for: indexPath) as! SelectionCollectionViewCell
        let item = testArray[indexPath.item]
        cell.iconImage.image = UIImage(named: item)
        return cell
    }
    
    // centering the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: section))
        let combinedItemWidth = (numberOfItems * flowLayout.itemSize.width) + ((numberOfItems - 1)  * flowLayout.minimumInteritemSpacing)
        let padding = (collectionView.frame.width - combinedItemWidth) / 2
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedItem = indexPath
        print(selectedItem.row)
        if selectedItem.row == 1 {
            let viewController = CustomizeWeatherViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        } else if selectedItem.row == 2 {
            let viewController = CustomizeSelectionsViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Need to set up customization views")
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white        
        collectionView.isPagingEnabled = false
        collectionView.bounces = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(SelectionCollectionViewCell.self, forCellWithReuseIdentifier: SelectionCollectionViewCell.identifier)
        return collectionView
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
