//
//  ViewController.swift
//  InfiniteLayout
//
//  Created by Arnoymous on 12/20/2017.
//  Copyright (c) 2017 Arnoymous. All rights reserved.
//

import UIKit
import InfiniteLayout

class ViewController: InfiniteCollectionViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let collectionView = self.collectionView else {
            return
        }
        
        let cells = collectionView.indexPathsForVisibleItems.sorted()
        for i in 0..<cells.count {
            guard let cell = collectionView.cellForItem(at: cells[i]) else {
                return
            }
            cell.alpha = 0
            UIView.animate(withDuration: 0.3, delay: TimeInterval(i) * 0.05, options: [], animations: {
                cell.alpha = 1
            }, completion: nil)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        cell.update(index: self.infiniteCollectionView!.indexPath(from: indexPath).row)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 100
        let width: CGFloat = height * 2
        return CGSize(width: width, height: height)
    }
}
