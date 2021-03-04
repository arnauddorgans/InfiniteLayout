//
//  InfiniteCollectionView+Rx.swift
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 03/01/2018.
//

#if canImport(InfiniteLayout)
import InfiniteLayout
#endif

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxInfiniteCollectionViewDelegate: DelegateProxy<InfiniteCollectionView, InfiniteCollectionViewDelegate>, DelegateProxyType, InfiniteCollectionViewDelegate {
    
    init(infiniteCollectionView: InfiniteCollectionView) {
        super.init(parentObject: infiniteCollectionView, delegateProxy: RxInfiniteCollectionViewDelegate.self)
    }
    
    static func registerKnownImplementations() {
        RxInfiniteCollectionViewDelegate.register {
            RxInfiniteCollectionViewDelegate(infiniteCollectionView: $0)
        }
    }
    
    static func currentDelegate(for object: InfiniteCollectionView) -> InfiniteCollectionViewDelegate? {
        return object.infiniteDelegate
    }
    
    static func setCurrentDelegate(_ delegate: InfiniteCollectionViewDelegate?, to object: InfiniteCollectionView) {
        object.infiniteDelegate = delegate
    }
}

extension Reactive where Base: InfiniteCollectionView {
    
    private var infiniteDelegate: RxInfiniteCollectionViewDelegate {
        return RxInfiniteCollectionViewDelegate.proxy(for: self.base)
    }
    
    public var itemCentered: ControlEvent<IndexPath?> {
        let source = infiniteDelegate.sentMessage(#selector(InfiniteCollectionViewDelegate.infiniteCollectionView(_:didChangeCenteredIndexPath:to:)))
            .map { $0.last as? IndexPath }
        return ControlEvent(events: source)
    }

    public func modelCentered<T>(_ type: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemCentered.flatMap { [weak view = self.base as InfiniteCollectionView] indexPath -> Observable<T> in
            guard let view = view, var indexPath = indexPath else {
                return Observable.empty()
            }

            indexPath.row %= InfiniteDataSources.originCount
            return Observable.just(try view.rx.model(at: indexPath))
        }
        return ControlEvent(events: source)
    }

    public func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = itemSelected.flatMap { [weak view = self.base as InfiniteCollectionView] indexPath -> Observable<T> in
            guard let view = view else {
                return Observable.empty()
            }

            var indexPath = indexPath
            indexPath.row %= InfiniteDataSources.originCount
            return Observable.just(try view.rx.model(at: indexPath))
        }

        return ControlEvent(events: source)
    }
}

extension Reactive where Base: RxInfiniteCollectionView {

    public func items<S: Sequence, O: ObservableType>
        (infinite: Bool)
        -> (_ source: O)
        -> (_ cellFactory: @escaping (UICollectionView, Int, S.Iterator.Element) -> UICollectionViewCell)
        -> Disposable where O.Element == S {
            return { source in
                guard infinite else {
                    return self.items(source)
                }
                return { cellFactory in
                    let dataSource = RxInfiniteCollectionViewSectionedReloadDataSource<SectionModel<Int, S.Iterator.Element>>(configureCell: { _, collectionView, indexPath, element in
                        return cellFactory(collectionView, indexPath.item, element)
                    })
                    return self.items(dataSource: dataSource)(source.map { [SectionModel(model: 0, items: $0.map { $0 })] })
                }
            }
    }
    
    public func items<S: Sequence, Cell: UICollectionViewCell, O : ObservableType>
        (cellIdentifier: String, cellType: Cell.Type = Cell.self, infinite: Bool)
        -> (_ source: O)
        -> (_ configureCell: @escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable where O.Element == S {
            guard infinite else {
                return self.items(cellIdentifier: cellIdentifier, cellType: cellType)
            }
            return { source in
                return { configureCell in
                    let dataSource = RxInfiniteCollectionViewSectionedReloadDataSource<SectionModel<Int, S.Iterator.Element>>(configureCell: { _, collectionView, indexPath, element in
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! Cell
                        configureCell(indexPath.item, element, cell)
                        return cell
                    })
                    return self.items(dataSource: dataSource)(source.map { [SectionModel(model: 0, items: $0.map { $0 })] })
                }
            }
    }
}
