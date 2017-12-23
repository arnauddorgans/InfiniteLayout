//
//  InfiniteCollectionViewProxy.m
//  InfiniteLayout
//
//  Created by Arnaud Dorgans on 21/12/2017.
//

#import "InfiniteCollectionViewProxy.h"

@implementation _InfiniteCollectionViewProxy

-(instancetype)init:(nullable id)collectionView exceptions:(nonnull NSArray<NSString*>*)exceptions {
    self.collectionView = collectionView;
    self.exceptions = exceptions;
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return ([self.collectionView respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector]);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSObject *delegateForResonse = [self.delegate respondsToSelector:aSelector] ? self.delegate : self.collectionView;
    NSMethodSignature *signature = [delegateForResonse respondsToSelector:aSelector] ? [delegateForResonse methodSignatureForSelector:aSelector] : nil;
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSString *selectorName = NSStringFromSelector(invocation.selector);

    NSArray<id<NSObject>> *delegates = @[self.delegate, self.collectionView];
    if ([self.exceptions containsObject:selectorName]) {
        delegates = [[delegates reverseObjectEnumerator] allObjects];
    }
    for (int i = 0; i < delegates.count; i++) {
        if ([delegates[i] respondsToSelector:invocation.selector]) {
            [self invokeInvocation:invocation onDelegate:delegates[i]];
            return;
        }
    }
}

- (void)invokeInvocation:(NSInvocation *)invocation onDelegate:(id<NSObject>)delegate
{
    if ([delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:delegate];
    }
}

@end
