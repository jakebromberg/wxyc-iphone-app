//
//  NSArray+Additions.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/9/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSString *)join:(NSString *)glue
{
	return [self componentsJoinedByString:glue];
}

- (NSString *)join
{
	return [self join:@""];
}

@end
