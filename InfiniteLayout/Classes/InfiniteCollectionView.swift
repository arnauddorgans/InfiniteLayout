//
//  InfiniteCollectionView.swift
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 20/12/2017.
//

import UIKit

@objc public protocol InfiniteCollectionViewDelegate {

    @objc optional func infiniteCollectionView(_ infiniteCollectionView: InfiniteCollectionView, didChangeCenteredIndexPath from: IndexPath?, to: IndexPath?)
}

open class InfiniteCollectionView: UICollectionView {
    
    lazy var dataSourceProxy = InfiniteCollectionViewDataSourceProxy(collectionView: self)
    lazy var delegateProxy = InfiniteCollectionViewDelegateProxy(collectionView: self)
    
    @IBOutlet open weak var infiniteDelegate: InfiniteCollectionViewDelegate?
    
    open private(set) var centeredIndexPath: IndexPath?
    open var preferredCenteredIndexPath: IndexPath? = IndexPath(item: 0, section: 0)
    
    var forwardDelegate: Bool { return true }
    var _contentSize: CGSize?
    
    override open weak var delegate: UICollectionViewDelegate? {
        get { return super.delegate }
        set {
            guard forwardDelegate else {
                super.delegate = newValue
                return
            }
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
    
    override open weak var dataSource: UICollectionViewDataSource? {
        get { return super.dataSource }
        set {
            guard forwardDelegate else {
                super.dataSource = newValue
                return
            }
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
    
    @IBInspectable open var isItemPagingEnabled: Bool = false
    @IBInspectable open var velocityMultiplier: CGFloat = 1 {
        didSet {
            self.infiniteLayout.velocityMultiplier = velocityMultiplier
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
        sharedInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let infiniteLayout = InfiniteCollectionView.infiniteLayout(layout: self.collectionViewLayout)
        if self.collectionViewLayout != infiniteLayout {
            self.collectionViewLayout = infiniteLayout
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        sharedInit()
    }
    
    private func sharedInit() {
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        #if os(iOS)
            self.scrollsToTop = false
        #endif
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateLayoutIfNeeded()
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
    
    private var multiplier: Int {
        return InfiniteDataSources.multiplier(estimatedItemSize: self.infiniteLayout.itemSize, enabled: self.infiniteLayout.isEnabled)
    }
    
    public func section(from infiniteSection: Int) -> Int {
        return InfiniteDataSources.section(from: infiniteSection, numberOfSections: delegateNumberOfSections)
    }
    
    public func indexPath(from infiniteIndexPath: IndexPath) -> IndexPath {
        return InfiniteDataSources.indexPath(from: infiniteIndexPath,
                                             numberOfSections: delegateNumberOfSections,
                                             numberOfItems: delegateNumberOfItems(in: infiniteIndexPath.section))
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return InfiniteDataSources.numberOfSections(numberOfSections: delegateNumberOfSections, multiplier: multiplier)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfiniteDataSources.numberOfItemsInSection(numberOfItemsInSection: delegateNumberOfItems(in: section),
                                                          numberOfSections: delegateNumberOfSections,
                                                          multiplier: multiplier)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("collectionView dataSource is required")
    }
}

extension InfiniteCollectionView: UICollectionViewDelegate {
    
    func updateLayoutIfNeeded() {
        self.loopCollectionViewIfNeeded()
        self.centerCollectionViewIfNeeded()
        
        let preferredVisibleIndexPath = infiniteLayout.preferredVisibleLayoutAttributes()?.indexPath
        if self.centeredIndexPath != preferredVisibleIndexPath {
            let previousCenteredIndexPath = self.centeredIndexPath
            self.centeredIndexPath = preferredVisibleIndexPath
            self.infiniteDelegate?.infiniteCollectionView?(self, didChangeCenteredIndexPath: previousCenteredIndexPath, to: self.centeredIndexPath)
        }
    }
    
    // MARK: Loop
    func loopCollectionViewIfNeeded() {
        self.infiniteLayout.loopCollectionViewIfNeeded()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegateProxy.delegate?.scrollViewDidScroll?(scrollView)
        self.updateLayoutIfNeeded()
    }
    
    // MARK: Paging
    func centerCollectionViewIfNeeded() {
        guard isItemPagingEnabled,
            !self.isDragging && !self.isDecelerating else {
                return
        }
        guard self._contentSize != self.contentSize else {
            return
        }
        self._contentSize = self.contentSize
        self.infiniteLayout.centerCollectionViewIfNeeded(indexPath: self.preferredCenteredIndexPath)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if isItemPagingEnabled {
            self.infiniteLayout.centerCollectionView(withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
        self.delegateProxy.delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
