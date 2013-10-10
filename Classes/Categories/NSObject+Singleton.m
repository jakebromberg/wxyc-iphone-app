//
//  NSObject+Singleton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/9/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "NSObject+Singleton.h"

@implementation NSObject (Singleton)

static NSObject *_sharedObject;

+ (id)sharedObject
{
	static dispatch_once_t initOnceToken;
	dispatch_once(&initOnceToken, ^{
		_sharedObject = [[self alloc] init];
	});
	
	return _sharedObject;
}

@end
