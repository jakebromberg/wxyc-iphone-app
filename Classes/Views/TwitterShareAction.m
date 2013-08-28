//
//  TwitterShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/21/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "TwitterShareAction.h"
#import <Social/Social.h>

@implementation TwitterShareAction

+ (NSString *)serviceName
{
	return @"Twitter";
}

+ (NSString *)SLServiceType
{
	return SLServiceTypeTwitter;
}

@end