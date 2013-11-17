//
//  NSObject+KVOBlocks.h
//  WXYCapp
//
//  Created by Jake Bromberg on 10/11/13.
//  WXYCapp
//

#import <Foundation/Foundation.h>

@interface NSObject (KVOBlocks)

typedef void (^ObservationBlock)(NSDictionary *change);

- (void)observeKeyPath:(NSString *)keyPath changeBlock:(ObservationBlock)block;
- (void)observeManyKeyPaths:(NSArray *)keyPaths changeBlock:(ObservationBlock)block;
- (void)addBlockObserver:(id)observer forKeyPath:(NSString *)keyPath changeBlock:(ObservationBlock)block;
- (void)addBlockObserver:(id)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeBlock:(ObservationBlock)block;

- (void)removeBlockObservers;
- (void)removeBlockObserver:(id)observer forKeyPath:(NSString *)keyPath;
- (void)removeBlockObserver:(id)observer;

@end
