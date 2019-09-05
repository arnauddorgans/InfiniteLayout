# InfiniteLayout

[![CI Status](http://img.shields.io/travis/arnauddorgans/InfiniteLayout.svg?style=flat)](https://travis-ci.org/arnauddorgans/InfiniteLayout)
[![License](https://img.shields.io/cocoapods/l/InfiniteLayout.svg?style=flat)](http://cocoapods.org/pods/InfiniteLayout)
[![Platform](https://img.shields.io/cocoapods/p/InfiniteLayout.svg?style=flat)](http://cocoapods.org/pods/InfiniteLayout)
[![Version](https://img.shields.io/cocoapods/v/InfiniteLayout.svg?style=flat)](http://cocoapods.org/pods/InfiniteLayout)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

<img src="https://github.com/arnauddorgans/InfiniteLayout/raw/master/horizontal.gif" width="250" height="540"><img src="https://github.com/arnauddorgans/InfiniteLayout/raw/master/vertical.gif" width="250" height="540"><img src="https://github.com/arnauddorgans/InfiniteLayout/raw/master/custom.gif" width="250" height="540">


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

InfiniteLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InfiniteLayout'
```


### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.

```swift
// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "InfiniteLayoutTestProject",
  dependencies: [
    .package(url: "https://github.com/arnauddorgans/InfiniteLayout.git", from: "0.4.2")
  ],
  targets: [
    .target(name: "InfiniteLayoutTestProject", dependencies: ["InfiniteLayout"])
  ]
)
```

## Usage

```swift
@IBOutlet weak var collectionView: InfiniteCollectionView!
```

InfiniteCollectionView doesn't need any other delegate or dataSource,
just use UICollectionViewDataSource and UICollectionViewDelegate in the same way as you'll use it in any other UICollectionView.

InfiniteLayout provides 3 classes for infinite scrolling:

**InfiniteLayout**: an UICollectionViewFlowLayout

**InfiniteCollectionView**: an UICollectionView with InfiniteLayout

**InfiniteCollectionViewController**: an UICollectionViewController with InfiniteCollectionView

### IndexPath

InfiniteCollectionView may create fake indexPath,

To get the real indexPath call 

```swift
func indexPath(from infiniteIndexPath: IndexPath) -> IndexPath
```

To get the real section call 

```swift
func section(from infiniteSection: Int) -> Int
```

### Paging

InfiniteCollectionView provide a paging functionality, you can enable it by setting the **isItemPagingEnabled** flag to **true**

```swift
self.infiniteCollectionView.isItemPagingEnabled = true
```

When the **isItemPagingEnabled** flag is enabled you can adjust the deceleration rate by setting the **velocityMultiplier**, the more the value is high, the more the deceleration is long

```swift
self.infiniteCollectionView.velocityMultiplier = 1 // like scrollView with paging (default value)
self.infiniteCollectionView.velocityMultiplier = 500 // like scrollView without paging
```

When the **isItemPagingEnabled** flag is enabled you can set a **preferredCenteredIndexPath**, this value is used to calculate the preferred visible cell to center each time the collectionView will change its contentSize

```swift
self.infiniteCollectionView.preferredCenteredIndexPath = [0, 0] // center the cell at [0, 0] if visible (default value)
self.infiniteCollectionView.preferredCenteredIndexPath = nil // center the closest cell from center
```

### Delegate

<img src="https://github.com/arnauddorgans/InfiniteLayout/raw/master/delegate.gif" width="250" height="540">

InfiniteCollectionView provide an **infiniteDelegate** protocol used to get the centered IndexPath, usefull if you want to use an InfiniteCollectionView like a Picker.

```swift
func infiniteCollectionView(_ infiniteCollectionView: InfiniteCollectionView, didChangeCenteredIndexPath from: IndexPath?, to: IndexPath?)
```

### Rx

InfiniteCollectionView provide a subspec **InfiniteLayout/Rx**
```ruby
pod 'InfiniteLayout/Rx'
```

To use InfiniteCollectionView with RxSwift without conflicts between NSProxy

Use **RxInfiniteCollectionView** instead of **InfiniteCollectionView**

```swift
@IBOutlet weak var collectionView: RxInfiniteCollectionView!
```

RxInfiniteCollectionView provides 2 dataSources for SectionModel:

**RxInfiniteCollectionViewSectionedReloadDataSource** and **RxInfiniteCollectionViewSectionedAnimatedDataSource**

#### Binding:

Without sections:
```swift
// automatic cell dequeue
Observable.just(Array(0..<2))
    .bind(to: infiniteCollectionView.rx.items(cellIdentifier: "cell", cellType: Cell.self, infinite: true)) { row, element, cell in
        cell.update(index: row) // update your cell
    }.disposed(by: disposeBag)
    
// custom cell dequeue
Observable.just(Array(0..<2))
    .bind(to: infiniteCollectionView.rx.items(infinite: true)) { collectionView, row, element in
        let indexPath = IndexPath(row: row, section: 0)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell // dequeue your cell
        cell.update(index: row) // update your cell
        return cell
    }.disposed(by: disposeBag)
```

With sections:
```swift
let dataSource = RxInfiniteCollectionViewSectionedReloadDataSource<SectionModel<Int, Int>>(configureCell: { dataSource, collectionView, indexPath, element in
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell // dequeue your cell
    cell.update(index: indexPath.row) // update your cell
    return cell
})

Observable.just([
                    SectionModel(model: 0, items: Array(0..<2)),
                    SectionModel(model: 1, items: Array(0..<10))
                ])
    .bind(to: infiniteCollectionView.rx.items(dataSource: dataSource))
    .disposed(by: disposeBag)
```

for animations just use **RxInfiniteCollectionViewSectionedAnimatedDataSource** & **AnimatableSectionModel**

#### Centered IndexPath:

RxInfiniteCollectionView provide Reactive extension for **itemCentered** & **modelCentered**
```swift
infiniteCollectionView.rx.itemCentered
    .asDriver()
    .drive(onNext: { [unowned self] indexPath in
        self.selectedView.update(index: indexPath.row) // update interface with indexPath
    }).disposed(by: disposeBag)

infiniteCollectionView.rx.modelCentered(Int.self)
    .asDriver()
    .drive(onNext: { [unowned self] element in
        self.selectedView.update(index: element) // update interface with model
    }).disposed(by: disposeBag)
```

## Author

Arnaud Dorgans, arnaud.dorgans@gmail.com

## License

InfiniteLayout is available under the MIT license. See the LICENSE file for more info.
