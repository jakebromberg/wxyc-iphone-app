//
//  NSObject+Singleton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/9/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "NSObject+Singleton.h"

@implementation NSObject (Singleton)

static NSMapTable *sharedObjects;

+ (void)load
{
	sharedObjects = [NSMapTable strongToStrongObjectsMapTable];
}

+ (void)loadSingleton
{
	[self sharedObject];
}

+ (instancetype)sharedObject
{
	id objectifiedSelf = [NSValue valueWithNonretainedObject:[self class]];
	
	if (![sharedObjects objectForKey:objectifiedSelf])
		[sharedObjects setObject:[[self alloc] init] forKey:objectifiedSelf];

	return [sharedObjects objectForKey:objectifiedSelf];
}

@end
