//
//  InfiniteCollectionView.swift
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 20/12/2017.
//

import UIKit

@objc public protocol InfiniteCollectionViewDelegate {
    
    @objc optional func infiniteCollectionView(_ infiniteCollectionView: InfiniteCollectionView, didChangeCenteredIndexPath centeredIndexPath: IndexPath?)
}

open class InfiniteCollectionView: UICollectionView {
    
    lazy var delegateProxy = InfiniteCollectionViewDelegateProxy(collectionView: self)
    lazy var dataSourceProxy = InfiniteCollectionViewDataSourceProxy(collectionView: self)
    
    @IBOutlet open var infiniteDelegate: InfiniteCollectionViewDelegate?
    
    open var centeredIndexPath: IndexPath?
    
    @IBInspectable var isItemPagingEnabled: Bool = false
    @IBInspectable var velocityMultiplier: CGFloat = 500 {
        didSet {
            self.infiniteLayout.velocityMultiplier = velocityMultiplier
        }
    }
    
    override open var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set {
            guard let newValue = newValue else {
                super.delegate = nil
                return
            }
            let isProxy = newValue is InfiniteCollectionViewDelegateProxy
            let delegate = isProxy ? newValue : delegateProxy
            if !isProxy {
                delegateProxy.delegate = newValue
            }
            super.delegate = delegate
        }
    }
    override open var dataSource: UICollectionViewDataSource? {
        get { return super.dataSource }
        set {
            guard let newValue = newValue else {
                super.dataSource = nil
                return
            }
            let isProxy = newValue is InfiniteCollectionViewDataSourceProxy
            let dataSource = isProxy ? newValue : dataSourceProxy
            if !isProxy {
                dataSourceProxy.delegate = newValue
            }
            super.dataSource = dataSource
        }
    }
    
    public var infiniteLayout: InfiniteLayout! {
        return self.collectionViewLayout as? InfiniteLayout
    }
    
    private static func infiniteLayout(layout: UICollectionViewLayout) -> InfiniteLayout {
        guard let infiniteLayout = layout as? InfiniteLayout else {
            return InfiniteLayout(layout: layout)
        }
        return infiniteLayout
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: InfiniteCollectionView.infiniteLayout(layout: layout))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let infiniteLayout = InfiniteCollectionView.infiniteLayout(layout: self.collectionViewLayout)
        if self.collectionViewLayout != infiniteLayout {
            self.collectionViewLayout = infiniteLayout
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.centerCollectionViewIfNeeded()
        self.loopCollectionViewIfNeeded()
    }
}

extension InfiniteCollectionView: UICollectionViewDelegate {
    
    // MARK: Loop
    func loopCollectionViewIfNeeded() {
        self.infiniteLayout.loopCollectionViewIfNeeded()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegateProxy.delegate?.scrollViewDidScroll?(scrollView)
        self.loopCollectionViewIfNeeded()
        
        let preferredVisibleIndexPath = infiniteLayout.preferredVisibleLayoutAttributes()?.indexPath
        if self.centeredIndexPath != preferredVisibleIndexPath {
            self.centeredIndexPath = preferredVisibleIndexPath
            self.infiniteDelegate?.infiniteCollectionView?(self, didChangeCenteredIndexPath: preferredVisibleIndexPath)
        }
    }
    
    // MARK: Paging
    func centerCollectionViewIfNeeded() {
        guard isItemPagingEnabled,
            !self.isDragging && !self.isDecelerating else {
                return
        }
        self.infiniteLayout.centerCollectionViewIfNeeded()
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if isItemPagingEnabled {
            self.infiniteLayout.centerCollectionView(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
}

// MARK: DataSource
extension InfiniteCollectionView: UICollectionViewDataSource {
    
    private var delegateNumberOfSections: Int {
        guard let sections = dataSourceProxy.delegate.flatMap({ $0.numberOfSections?(in: self) ?? 1 }) else {
            fatalError("collectionView dataSource is required")
        }
        return sections
    }
    
    private func delegateNumberOfItems(in section: Int) -> Int {
        guard let items = dataSourceProxy.delegate.flatMap({ $0.collectionView(self, numberOfItemsInSection: self.section(from: section)) }) else {
            fatalError("collectionView dataSource is required")
        }
        return items
    }
    
    public func section(from infiniteSection: Int) -> Int {
        return infiniteSection % delegateNumberOfSections
    }
    
    public func indexPath(from infiniteIndexPath: IndexPath) -> IndexPath {
        let items = delegateNumberOfItems(in: infiniteIndexPath.section)
        return IndexPath(item: infiniteIndexPath.item % items, section: self.section(from: infiniteIndexPath.section))
    }
    
    private var multiplier: Int {
        let min = Swift.min(self.infiniteLayout.itemSize.width, self.infiniteLayout.itemSize.height)
        let count = ceil(InfiniteLayout.minimumContentSize.width / min)
        return Int(count) * delegateNumberOfSections
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let delegateNumberOfSections = self.delegateNumberOfSections
        return delegateNumberOfSections > 1 ? delegateNumberOfSections * multiplier : delegateNumberOfSections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let delegateNumberOfSections = self.delegateNumberOfSections
        let delegateNumberOfItems = self.delegateNumberOfItems(in: section)
        return delegateNumberOfSections > 1 ? delegateNumberOfItems : delegateNumberOfItems * multiplier
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("collectionView dataSource is required")
    }
}
