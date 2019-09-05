//
//  CocoaProxy.h
//  CocoaProxy
//
//  Created by Arnaud Dorgans on 27/12/2017.
//

#import <Foundation/Foundation.h>

@interface CocoaProxy : NSProxy

- (instancetype _Nonnull)init;
- (instancetype _Nonnull)initWithProxies:(nonnull NSArray<id<NSObject>>*)proxies;

- (NSArray<id<NSObject>> *_Nonnull)proxiesForSelector:(SEL _Nonnull )aSelector;

@property (nonatomic, strong) NSArray<id<NSObject>>* _Nonnull proxies;
@property (nonatomic, copy) BOOL (^ _Nullable proxyFilter)(id<NSObject> _Nonnull proxy, SEL _Nonnull selector);

@end
