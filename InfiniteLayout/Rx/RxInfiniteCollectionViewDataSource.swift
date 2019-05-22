//
//  RxInfiniteCollectionViewDelegate.swift
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 03/01/2018.
//

import UIKit
import RxDataSources

open class RxInfiniteCollectionViewSectionedReloadDataSource<S: SectionModelType>: RxCollectionViewSectionedReloadDataSource<S> {
    
    public var isEnabled: Bool = true

    open override subscript(section: Int) -> S {
        let section = InfiniteDataSources.section(from: section, numberOfSections: sectionModels.count)
        return self.sectionModels[section]
    }
    
    open override subscript(indexPath: IndexPath) -> Item {
        get {
            let indexPath = InfiniteDataSources.indexPath(from: indexPath,
                                                          numberOfSections: sectionModels.count,
                                                          numberOfItems: self[indexPath.section].items.count)
            return super[indexPath]
        } set {
            let indexPath = InfiniteDataSources.indexPath(from: indexPath,
                                                          numberOfSections: sectionModels.count,
                                                          numberOfItems: self[indexPath.section].items.count)
            super[indexPath] = newValue
        }
    }
    
    private func multiplier(for collectionView: UICollectionView) -> Int {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError()
        }
        return InfiniteDataSources.multiplier(estimatedItemSize: layout.itemSize, enabled: isEnabled)
    }
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return InfiniteDataSources.numberOfSections(numberOfSections: self.sectionModels.count,
                                                    multiplier: self.multiplier(for: collectionView))
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfiniteDataSources.numberOfItemsInSection(numberOfItemsInSection: self[section].items.count,
                                                          numberOfSections: self.sectionModels.count,
                                                          multiplier: self.multiplier(for: collectionView))
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {        
        return configureCell(self, collectionView, indexPath, self[indexPath])
    }
}

open class RxInfiniteCollectionViewSectionedAnimatedDataSource<S: AnimatableSectionModelType>: RxCollectionViewSectionedAnimatedDataSource<S> {
    
    public var isEnabled: Bool = true
    
    open override subscript(section: Int) -> S {
        let section = InfiniteDataSources.section(from: section, numberOfSections: sectionModels.count)
        return self.sectionModels[section]
    }
    
    open override subscript(indexPath: IndexPath) -> Item {
        get {
            let indexPath = InfiniteDataSources.indexPath(from: indexPath,
                                                          numberOfSections: sectionModels.count,
                                                          numberOfItems: self[indexPath.section].items.count)
            return super[indexPath]
        } set {
            let indexPath = InfiniteDataSources.indexPath(from: indexPath,
                                                          numberOfSections: sectionModels.count,
                                                          numberOfItems: self[indexPath.section].items.count)
            super[indexPath] = newValue
        }
    }
    
    private func multiplier(for collectionView: UICollectionView) -> Int {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError()
        }
        return InfiniteDataSources.multiplier(estimatedItemSize: layout.itemSize, enabled: isEnabled)
    }
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return InfiniteDataSources.numberOfSections(numberOfSections: self.sectionModels.count,
                                                    multiplier: self.multiplier(for: collectionView))
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InfiniteDataSources.numberOfItemsInSection(numberOfItemsInSection: self[section].items.count,
                                                          numberOfSections: self.sectionModels.count,
                                                          multiplier: self.multiplier(for: collectionView))
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configureCell(self, collectionView, indexPath, self[indexPath])
    }
}
