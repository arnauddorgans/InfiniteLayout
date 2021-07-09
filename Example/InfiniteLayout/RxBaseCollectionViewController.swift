//
//  RxBaseCollectionViewController.swift
//  InfiniteLayout_Example
//
//  Created by Arnaud Dorgans on 03/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import InfiniteLayout

class RxBaseCollectionViewController: UIViewController {
    
    @IBOutlet weak var infiniteCollectionView: RxInfiniteCollectionView!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just(Array(0..<20))
            .bind(to: infiniteCollectionView.rx.items(cellIdentifier: "cell", cellType: Cell.self, infinite: true)) { _, index, cell in
                cell.update(index: index)
            }.disposed(by: disposeBag)
        
        infiniteCollectionView.rx.modelCentered(Int.self)
            .asDriver()
            .drive(onNext: { current in
                print("centered: \(current + 1)")
            }).disposed(by: disposeBag)
        
        infiniteCollectionView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [unowned self] indexPath in
                self.infiniteCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            }).disposed(by: disposeBag)
    }
}
