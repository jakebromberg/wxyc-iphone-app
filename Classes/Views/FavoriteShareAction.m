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
#import "UIApplication+PresentViewController.h"

@implementation FavoriteShareAction

+ (void)sharePlaycut:(Playcut *)playcut
{
    NSURLRequest *request = [FavoriteShareAction urlRequestForPlaycut:playcut];
	WebViewController *webViewController = [[WebViewController alloc] initWithRequest:request];
    [UIApplication presentViewController:webViewController animated:YES completion:nil];
}

+ (NSURLRequest *)urlRequestForPlaycut:(Playcut *)playcut
{
	NSString *artist = [[playcut valueForKey:@"artist"] urlEncodeUsingEncoding:NSUTF8StringEncoding];
	NSString *song = [[playcut valueForKey:@"song"] urlEncodeUsingEncoding:NSUTF8StringEncoding];
	NSString *url = [@"http://google.com/search?q=%@+%@" formattedWith:@[artist, song]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    return request;
}

@end
