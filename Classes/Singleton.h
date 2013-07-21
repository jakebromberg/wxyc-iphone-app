//
//  Singleton.h
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SINGLETON_DECLARATION(CLASS) \
@interface CLASS (Singleton) \
\
+ (CLASS *)sharedInstance; \
\
@end \


#define SINGLETON_IMPLEMENTATION(CLASS) \
@implementation CLASS (Singleton) \
\
+ (CLASS *)sharedInstance \
{ \
	static dispatch_once_t pred = 0;\
	__strong static id _sharedObject = nil; \
	dispatch_once(&pred, ^{ \
		_sharedObject = [[CLASS alloc] init]; \
	}); \
	return _sharedObject; \
} \
\
@end