//
//  BreakpointMapping.m
//  WXYCapp
//
//  Created by Jake Bromberg on 5/24/14.
//  Copyright (c) 2014 WXYC. All rights reserved.
//

#import "BreakpointMapping.h"
#import "Breakpoint.h"

@implementation BreakpointMapping

+ (NSString *)entityName
{
	return NSStringFromClass([Breakpoint class]);
}

+ (NSDictionary *)attributeMappings
{
	return @{
		@"id" : @"id",
		@"chronOrderID" : @keypath(Breakpoint *, chronOrderID),
		@"hour" : @keypath(Breakpoint *, hour)
	};
}

+ (NSArray *)identificationAttributes
{
	return @[@"id"];
}

+ (NSString *)keyPath
{
	return @"breakpoints";
}

@end
