//
//  InfiniteCollectionViewProxy.h
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 21/12/2017.
//

#import <Foundation/Foundation.h>

@interface _InfiniteCollectionViewProxy<T: id<NSObject>> : NSProxy <UICollectionViewDelegate, UICollectionViewDataSource>

-(nonnull instancetype)init:(nullable T)collectionView exceptions:(nonnull NSArray<NSString*>*)exceptions;

@property (nonatomic, weak, nullable) T collectionView;
@property (nonatomic, weak, nullable) T delegate;
@property (nonatomic, nonnull, retain) NSArray* exceptions;


@end
