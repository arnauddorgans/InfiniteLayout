//
//  InfiniteCollectionViewController.swift
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 23/12/2017.
//

import UIKit

open class InfiniteCollectionViewController: UICollectionViewController {

    public var infiniteCollectionView: InfiniteCollectionView? {
        return self.collectionView as? InfiniteCollectionView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = self.infiniteCollectionView else {
            fatalError("InfiniteCollectionView is needed")
        }
    }
}
