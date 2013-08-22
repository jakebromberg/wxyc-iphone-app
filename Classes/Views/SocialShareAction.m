//
//  SocialShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "SocialShareAction.h"
#import "NSString+Additions.h"
#import "UIAlertView+MKBlockAdditions.h"

@implementation SocialShareAction

+ (NSString *)SLServiceType
{
	NSAssert(NO, @"Override");
	return nil;
}

+ (NSString *)serviceName
{
	NSAssert(NO, @"Override");
	return nil;
}

+ (void)sharePlaycut:(Playcut *)playcut
{
	if ([SLComposeViewController isAvailableForServiceType:self.class.SLServiceType])
	{
		SLComposeViewController *sheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
		
		NSString *song = [playcut valueForKey:@"song"];
		NSString *artist = [playcut valueForKey:@"artist"];
		NSString *initialText = [@"Listening to \"%@\" by %@ on @WXYC!" formattedWith:@[song, artist]];
		[sheet setInitialText:initialText];
		
		UIImage *image = [UIImage imageWithData:[playcut valueForKey:@"primaryImage"]];
		[sheet addImage:image];
		[sheet addURL:[NSURL URLWithString:@"http://wxyc.org/"]];
		
		[[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:sheet animated:YES completion:nil];
	} else {
		id title = [@"Not logged in to " append:self.class.serviceName];
		id message = [@"Open Settings and add your %@ account" formattedWith:@[self.class.serviceName]];
		[[UIAlertView alertViewWithTitle:title message:message] show];
	}
}

@end
