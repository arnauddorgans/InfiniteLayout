//
//  RxInfiniteCollectionView.swift
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 03/01/2018.
//

#if canImport(RxSwift)

import UIKit
import RxSwift
import RxCocoa

open class RxInfiniteCollectionView: InfiniteCollectionView {
    
    let disposeBag = DisposeBag()

    override var forwardDelegate: Bool {
        return false
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupRx()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        setupRx()
    }
    
    func setupRx() {

        self.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

#endif
