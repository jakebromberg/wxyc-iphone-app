//
//  SocialShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "SocialShareAction.h"

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
		
		[sheet setInitialText:({
			NSString *song = playcut.Song ?: @"";
			NSString *artist = playcut.Artist ?: @"";
			[NSString stringWithFormat:@"Listening to \"%@\" by %@ on @WXYC!", song, artist];
		})];
		
		[sheet addImage:[UIImage imageWithData:playcut.PrimaryImage]];
		[sheet addURL:[NSURL URLWithString:@"http://wxyc.org/"]];
		
		[[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:sheet animated:YES completion:nil];
	} else {
		UIAlertController *alertViewController = [UIAlertController
			alertControllerWithTitle:[@"Not logged in to " stringByAppendingString:self.class.serviceName]
							 message:[NSString stringWithFormat:@"Open Settings and add your %@ account", self.class.serviceName]
					  preferredStyle:UIAlertControllerStyleAlert];
		
		[alertViewController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
		
		[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
	}
}

@end
