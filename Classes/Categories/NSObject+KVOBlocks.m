//
//  NSObject+KVOBlocks.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/11/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "NSObject+KVOBlocks.h"

@interface XYCKVOProxy : NSObject

- (instancetype)initWithObserver:(id)observer;

- (void)addObservationBlock:(ObservationBlock)block forKeyPath:(NSString *)keypath options:(NSKeyValueObservingOptions)options;
- (void)removeAllObservationBlocks;
- (void)removeObservationBlockForKeyPath:(NSString *)keypath;

@property (nonatomic, retain) NSMutableSet *keyPaths;
@property (nonatomic, assign) id observer;

@end

@implementation XYCKVOProxy

- (instancetype)initWithObserver:(id)observer
{
    self = [super init];
    
    if (!self)
        return nil;
    
	self.keyPaths = [NSMutableSet set];
    self.observer = observer;
    
    return self;
}

- (void)addObservationBlock:(ObservationBlock)block forKeyPath:(NSString *)keypath options:(NSKeyValueObservingOptions)options
{
	[self.keyPaths addObject:keypath];
    [self.observer addObserver:self forKeyPath:keypath options:options context:(__bridge_retained void *)([block copy])];
}

- (void)removeAllObservationBlocks
{
	for (NSString *keypath in self.keyPaths) {
		[self.observer removeObserver:self forKeyPath:keypath];
	}
	
	[self.keyPaths removeAllObjects];
}

- (void)removeObservationBlockForKeyPath:(NSString *)keypath
{
    [self.observer removeObserver:self forKeyPath:keypath];
	[self.keyPaths removeObject:keypath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	@try {
		ObservationBlock block = (__bridge ObservationBlock) context;
		block(change);
	}
	@catch (NSException *exception) {
		NSLog(@"%@", exception);
	}
}

@end


@implementation NSObject (KVOBlocks)

- (void)observeManyKeyPaths:(NSArray *)keyPaths changeBlock:(ObservationBlock)block
{
	for (NSString *keyPath in keyPaths) {
		[self observeKeyPath:keyPath changeBlock:block];
	}
}

- (void)observeKeyPath:(NSString *)keyPath changeBlock:(ObservationBlock)block
{
	[self addBlockObserver:self forKeyPath:keyPath changeBlock:block];
}

- (void)addBlockObserver:(id)observer forKeyPath:(NSString *)keyPath changeBlock:(ObservationBlock)block
{
	NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
	[self addBlockObserver:observer forKeyPath:keyPath options:options changeBlock:block];
}

- (void)addBlockObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options changeBlock:(ObservationBlock)block
{
    XYCKVOProxy *proxy = [self.observerProxyMap objectForKey:[NSValue valueWithPointer:&observer]];
    
    if (!proxy)
    {
        proxy = [[XYCKVOProxy alloc] initWithObserver:observer];
		[self.observerProxyMap setObject:proxy forKey:[NSValue valueWithPointer:&observer]];
    }
    
    [proxy addObservationBlock:block forKeyPath:keyPath options:options];
}

- (void)removeBlockObservers
{
	for (NSValue *observerValue in [self observerProxyMap])
	{
		XYCKVOProxy *proxy = [self.observerProxyMap objectForKey:observerValue];
		[proxy removeAllObservationBlocks];
		proxy = nil;
	}
	
	[self.observerProxyMap removeAllObjects];
}

- (void)removeBlockObserver:(NSObject *)observer
{
	NSValue *observerValue = [NSValue valueWithPointer:&observer];
	
    XYCKVOProxy *proxy = [self.observerProxyMap objectForKey:observerValue];
	[proxy removeAllObservationBlocks];
	proxy = nil;
	
	[[self observerProxyMap] removeObjectForKey:observerValue];
}

- (void)removeBlockObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    XYCKVOProxy *proxy = [self.observerProxyMap objectForKey:observer];
    [proxy removeObservationBlockForKeyPath:keyPath];
}

- (NSMapTable *)observerProxyMap
{
	static NSMapTable __strong *objectToProxyListMap;
	
	if (!objectToProxyListMap)
		objectToProxyListMap = [NSMapTable weakToStrongObjectsMapTable];
	
	if (![objectToProxyListMap objectForKey:self])
		[objectToProxyListMap setObject:[NSMapTable strongToStrongObjectsMapTable] forKey:self];
	
	return [objectToProxyListMap objectForKey:self];
}

@end
