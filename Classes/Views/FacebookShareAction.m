//
//  FacebookShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 8/27/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "FacebookShareAction.h"

@implementation FacebookShareAction

+ (NSString *)serviceName
{
	return @"Facebook";
}

+ (NSString *)SLServiceType
{
	return SLServiceTypeFacebook;
}

@end
