//
//  BaseCollectionViewController.swift
//  InfiniteLayout_Example
//
//  Created by Arnaud Dorgans on 29/12/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import InfiniteLayout

class BaseCollectionViewController: InfiniteCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell else {
            fatalError()
        }
        cell.update(index: self.infiniteCollectionView!.indexPath(from: indexPath).row)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
}
