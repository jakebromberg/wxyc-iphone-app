//
//  SearchShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/15/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "SearchShareAction.h"
#import "NSString+Additions.h"
#import "WebViewController.h"

@implementation SearchShareAction

+ (void)sharePlaycut:(Playcut *)playcut
{
	NSString *artist = [playcut.Artist urlEncodeUsingEncoding:NSUTF8StringEncoding];
	NSString *song = [playcut.Song urlEncodeUsingEncoding:NSUTF8StringEncoding];
	
	NSString *url = [@"http://google.com/search?q=%@+%@" formattedWith:@[artist, song]];
	WebViewController *webViewController = [[WebViewController alloc] init];
	[[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:webViewController animated:YES completion:nil];
	[webViewController loadURL:[NSURL URLWithString:url]];
}

@end
