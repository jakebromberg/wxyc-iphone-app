//
//  SearchShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/15/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "SearchShareAction.h"
#import "NSArray+Additions.h"
#import "SimpleWebBrowser.h"
#import "UIApplication+PresentViewController.h"
#import "NSObject+ObjectBuilder.h"

@implementation SearchShareAction

+ (void)sharePlaycut:(Playcut *)playcut
{
	SimpleWebBrowser *browser = [[SimpleWebBrowser alloc] initWithURL:[self urlForPlaycut:playcut]];
	[UIApplication presentViewController:browser];
}

+ (NSURL *)urlForPlaycut:(Playcut *)playcut
{
	NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithPropertyDictionary:@{
		@"scheme" : @"http",
		@"host" : @"google.com",
		@"path" : @"/search",
		@"query" : [self queryForPlaycut:playcut]
	}];
	
	return [urlComponents URL];
}

+ (NSString *)queryForPlaycut:(Playcut *)playcut
{
	return [@[playcut.Artist, playcut.Song] join:@"+"];
}

@end
