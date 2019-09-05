//
//  CocoaProxy.m
//  CocoaProxy
//
//  Created by Arnaud Dorgans on 27/12/2017.
//

#import "CocoaProxy.h"

@interface CocoaProxy () { }

@property (nonatomic, strong) NSPointerArray *pointerArray;

@end

@implementation CocoaProxy

- (instancetype _Nonnull)initWithProxies:(nonnull NSArray<NSObject*>*)proxies {
    [self setProxies: proxies];
    return self;
}

- (instancetype _Nonnull)init {
    return [self initWithProxies: @[]];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return ([self methodSignatureForSelector: aSelector] != nil);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    for (NSObject* proxy in [self proxiesForSelector: aSelector]) {
        if ([proxy respondsToSelector: aSelector]) {
            return [proxy methodSignatureForSelector: aSelector];
        }
    }
    return nil;
}

- (NSArray<id<NSObject>> *_Nonnull)proxiesForSelector:(SEL _Nonnull )aSelector
{
    if (self.proxyFilter) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return self.proxyFilter(evaluatedObject, aSelector);
        }];
        return [self.proxies filteredArrayUsingPredicate: predicate];
    }
    return self.proxies;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    for (NSObject* proxy in [self proxiesForSelector: invocation.selector]) {
        [self invokeInvocation: invocation onProxy: proxy];
    }
}

- (BOOL)invokeInvocation:(NSInvocation *)invocation onProxy:(id<NSObject>)proxy
{
    if ([proxy respondsToSelector: invocation.selector]) {
        [invocation invokeWithTarget: proxy];
        return YES;
    }
    return NO;
}

- (void)setProxies:(NSArray<id<NSObject>> *)proxies {
    self.pointerArray = [NSPointerArray weakObjectsPointerArray];
    for (NSObject* proxy in proxies) {
        [self.pointerArray addPointer: (void *)proxy];
    }
}

- (NSArray<id<NSObject>> *)proxies {
    return self.pointerArray.allObjects;
}

@end
