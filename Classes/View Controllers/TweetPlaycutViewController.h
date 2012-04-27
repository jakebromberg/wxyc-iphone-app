//
//  ShareItemTextInputViewController.h
//  WXYCapp
//
//  Created by Jake on 11/16/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SA_OAuthTwitterEngine.h"
//#import "SA_OAuthTwitterController.h"
#import "ShareItemTextInputViewController.h"
#import "ShareItemTextInputAccessoryInsertButton.h"

@class SA_OAuthTwitterEngine;

@interface TweetPlaycutViewController : ShareItemTextInputViewController <UINavigationControllerDelegate> 
{
//    SA_OAuthTwitterEngine *twitterEngine;
//	OAToken *token;
	
	NSString *myConsumerKey;
	NSString *myConsumerSecret;
}

- (IBAction)pushedArtist:(id)sender;
- (IBAction)pushedTitle:(id)sender;
- (IBAction)pushedAlbum:(id)sender;
- (IBAction)pushedWXYC:(id)sender;

@end
