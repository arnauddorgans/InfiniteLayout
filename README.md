# InfiniteLayout

[![CI Status](http://img.shields.io/travis/Arnoymous/InfiniteLayout.svg?style=flat)](https://travis-ci.org/Arnoymous/InfiniteLayout)
[![Version](https://img.shields.io/cocoapods/v/InfiniteLayout.svg?style=flat)](http://cocoapods.org/pods/InfiniteLayout)
[![License](https://img.shields.io/cocoapods/l/InfiniteLayout.svg?style=flat)](http://cocoapods.org/pods/InfiniteLayout)
[![Platform](https://img.shields.io/cocoapods/p/InfiniteLayout.svg?style=flat)](http://cocoapods.org/pods/InfiniteLayout)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

InfiniteLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InfiniteLayout'
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

InfiniteCollectionView provide a paging functionality, you can enable it by setting the **isItemPagingEnabled** flag to **true**,

When the **isItemPagingEnabled** flag is enabled you can adjust the deceleration rate by setting the **velocityMultiplier**, the more the value is high, the more the deceleration is long

## Author

Arnoymous, ineox@me.com

## License

InfiniteLayout is available under the MIT license. See the LICENSE file for more info.
