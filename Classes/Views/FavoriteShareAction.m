//
//  FavoriteShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/21/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "FavoriteShareAction.h"

@implementation FavoriteShareAction

+ (void)sharePlaycut:(Playcut *)playcut
{
	if ([playcut.Favorite isEqual:@YES])
	{
		UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"💔" message:@"Unlove this track, for real?" preferredStyle:UIAlertControllerStyleAlert];
		
		[alertViewController addAction:[UIAlertAction actionWithTitle:@"Unlove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
		{
			playcut.Favorite = @NO;
			[playcut.managedObjectContext saveToPersistentStoreAndWait];
		}]];
		
		[alertViewController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
		
		[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
	}
	else
	{
		playcut.Favorite = @YES;
		[playcut.managedObjectContext saveToPersistentStoreAndWait];
	}
}

@end
