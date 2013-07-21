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
	if ([[playcut valueForKey:@"favorite"] isEqual:@YES])
		[UIAlertView alertViewWithTitle:nil message:@"Unlove this track, for real?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Unlove"] onDismiss:^(int buttonIndex)
		 {
			 [playcut setValue:@NO forKey:@"favorite"];
			 [playcut.managedObjectContext saveToPersistentStoreAndWait];
		 } onCancel:^{
			 
		 }];
	else
	{
		[playcut setValue:@YES forKey:@"favorite"];
		[playcut.managedObjectContext saveToPersistentStoreAndWait];
	}
}

@end
