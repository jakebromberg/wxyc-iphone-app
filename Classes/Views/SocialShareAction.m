//
//  SocialShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialShareAction.h"
#import "NSString+Additions.h"
#import "WXYCAppDelegate.h"
#import "UIAlertView+MKBlockAdditions.h"

@implementation SocialShareAction

@dynamic SLServiceType;
@dynamic serviceName;

+ (void)sharePlaycut:(Playcut *)playcut
{
	if ([SLComposeViewController isAvailableForServiceType:[SocialShareAction sharedInstance].SLServiceType])
	{
		SLComposeViewController *sheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
		
		NSString *initialText = [@"Listening to \"%@\" by %@ on @WXYC!" formattedWith:@[playcut.song, playcut.artist]];
		[sheet setInitialText:initialText];
		[sheet addImage:playcut.primaryImage];
		[sheet addURL:[NSURL URLWithString:@"http://wxyc.org/"]];
		
		[[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:sheet animated:YES completion:nil];
	} else {
		id title = [@"Not logged in to " append:[SocialShareAction sharedInstance].serviceName];
		id message = [@"Open Settings and add your %@ account" formattedWith:@[[SocialShareAction sharedInstance].serviceName]];
		[[UIAlertView alertViewWithTitle:title message:message] show];
	}
}

@end

SINGLETON_IMPLEMENTATION(SocialShareAction)