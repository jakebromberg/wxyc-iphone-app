//
//  FavoriteShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/21/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "FavoriteShareAction.h"
#import "NSString+Additions.h"
#import "WebViewController.h"

@implementation FavoriteShareAction

+ (void)sharePlaycut:(Playcut *)playcut
{
	NSString *artist = [[playcut valueForKey:@"artist"] urlEncodeUsingEncoding:NSUTF8StringEncoding];
	NSString *song = [[playcut valueForKey:@"song"] urlEncodeUsingEncoding:NSUTF8StringEncoding];
	
	NSString *url = [@"http://google.com/search?q=%@+%@" formattedWith:@[artist, song]];
	WebViewController *webViewController = [[WebViewController alloc] init];
	[[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:webViewController animated:YES completion:nil];
	[webViewController loadURL:[NSURL URLWithString:url]];
}

@end
