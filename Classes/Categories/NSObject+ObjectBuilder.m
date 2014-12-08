//
//  NSObject+ObjectBuilder.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/23/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "NSObject+ObjectBuilder.h"

@implementation NSObject (ObjectBuilder)

- (instancetype)initWithPropertyDictionary:(NSDictionary *)dictionary
{
	if (!(self = [self init])) return nil;
	
	[self setValuesForKeysWithDictionary:dictionary];
	
	return self;
}

@end
