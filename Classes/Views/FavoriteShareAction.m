//
//  FavoriteShareAction.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/21/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "FavoriteShareAction.h"
#import "UIAlertView+MKBlockAdditions.h"

@implementation FavoriteShareAction

+ (void)sharePlaycut:(Playcut *)playcut
{
	if ([playcut.Favorite isEqual:@YES])
	{
		[UIAlertView alertViewWithTitle:@"💔" message:@"Unlove this track, for real?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Unlove"] onDismiss:^(int buttonIndex)
		 {
			 playcut.Favorite = @NO;
			 [playcut.managedObjectContext saveToPersistentStoreAndWait];
		 } onCancel:^{
			 return;
		 }];
	}
	else
	{
		playcut.Favorite = @YES;
		[playcut.managedObjectContext saveToPersistentStoreAndWait];
	}
}

@end
