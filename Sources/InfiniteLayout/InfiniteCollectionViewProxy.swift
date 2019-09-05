//
//  Proxy.swift
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 20/12/2017.
//

import UIKit

class InfiniteCollectionViewProxy<T: NSObjectProtocol>: CocoaProxy {
    
    var collectionView: InfiniteCollectionView! {
        get { return self.proxies.first as? InfiniteCollectionView }
        set {
            if !self.proxies.isEmpty {
                self.proxies.removeFirst()
            }
            self.proxies.insert(newValue, at: 0)
        }
    }
    
    var delegate: T? {
        get {
            guard self.proxies.count > 1 else {
                return nil
            }
            return self.proxies.last as? T
        } set {
            while self.proxies.count > 1 {
                self.proxies.removeLast()
            }
            guard let delegate = newValue else {
                return
            }
            self.proxies.append(delegate)
        }
    }
    
    override func proxies(for aSelector: Selector) -> [NSObjectProtocol] {
         return super.proxies(for: aSelector).reversed()
    }
    
    init(collectionView: InfiniteCollectionView) {
        super.init(proxies: [])
        self.collectionView = collectionView
    }
    
    deinit {
        self.proxies.removeAll()
    }
}

class InfiniteCollectionViewDelegateProxy: InfiniteCollectionViewProxy<UICollectionViewDelegate>, UICollectionViewDelegate {
    
    override func proxies(for aSelector: Selector) -> [NSObjectProtocol] {
        return super.proxies(for: aSelector)
            .first { proxy in
                guard !(aSelector == #selector(UIScrollViewDelegate.scrollViewDidScroll(_:)) ||
                    aSelector == #selector(UIScrollViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:))) else {
                        return proxy is InfiniteCollectionView
                }
                return true
            }.flatMap { [$0] } ?? []
    }
}

class InfiniteCollectionViewDataSourceProxy: InfiniteCollectionViewProxy<UICollectionViewDataSource>, UICollectionViewDataSource {
    
    override func proxies(for aSelector: Selector) -> [NSObjectProtocol] {
        return super.proxies(for: aSelector)
            .first { proxy in
                guard !(aSelector == #selector(UICollectionViewDataSource.numberOfSections(in:)) ||
                    aSelector == #selector(UICollectionViewDataSource.collectionView(_:numberOfItemsInSection:))) else {
                        return proxy is InfiniteCollectionView
                }
                return true
            }.flatMap { [$0] } ?? []
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionView.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.delegate?.collectionView(collectionView, cellForItemAt: indexPath) ??
            self.collectionView.collectionView(collectionView, cellForItemAt: indexPath)
    }
}
