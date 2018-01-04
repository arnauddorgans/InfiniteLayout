//
//  PickerController.swift
//  InfiniteLayout_Example
//
//  Created by Arnaud Dorgans on 03/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import InfiniteLayout

class PickerController: UIViewController {
    
    @IBOutlet weak var selectedView: CellView!
    @IBOutlet weak var infiniteCollectionView: InfiniteCollectionView!
}

extension PickerController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {
            fatalError()
        }
        cell.update(index: self.infiniteCollectionView.indexPath(from: indexPath).row)
        return cell
    }
}

extension PickerController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension PickerController: InfiniteCollectionViewDelegate {
    
    func infiniteCollectionView(_ infiniteCollectionView: InfiniteCollectionView, didChangeCenteredIndexPath centeredIndexPath: IndexPath?) {
        guard let indexPath = centeredIndexPath else {
            return
        }
        self.selectedView.update(index: self.infiniteCollectionView.indexPath(from: indexPath).row)
    }
}
