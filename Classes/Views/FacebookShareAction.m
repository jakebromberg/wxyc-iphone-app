//
//  FacebookShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/21/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "FacebookShareAction.h"
#import <Social/Social.h>

@implementation FacebookShareAction

- (NSString *)SLServiceType
{
	return SLServiceTypeFacebook;
}

- (NSString *)serviceName
{
	return @"Facebook";
}

@end
