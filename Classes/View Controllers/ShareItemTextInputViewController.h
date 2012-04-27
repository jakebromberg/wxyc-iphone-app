//
//  ShareItemTextInputViewController.h
//  WXYCapp
//
//  Created by Jake on 12/1/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playcut.h"
#import "MBProgressHUD.h"

@interface ShareItemTextInputViewController : UIViewController<UITextViewDelegate, MBProgressHUDDelegate> {
	UITextView *myTextView;
	UIView *accessoryView;

	NSString *artistString;
	NSString *titleString;
	NSString *albumString;
	
	MBProgressHUD *HUD;
}

@property (nonatomic, retain) IBOutlet UITextView *myTextView;
@property (nonatomic, assign) IBOutlet UIView *accessoryView;

@property (nonatomic, assign) IBOutlet UIButton *artistButton;
@property (nonatomic, assign) IBOutlet UIButton *titleButton;
@property (nonatomic, assign) IBOutlet UIButton *albumButton;
@property (nonatomic, assign) IBOutlet UIButton *wxycButton;
@property (nonatomic, assign) IBOutlet UILabel *charCountLabel; //TODO: move this to the twitter share class

@property (nonatomic, assign) NSString *artistString;
@property (nonatomic, assign) NSString *titleString;
@property (nonatomic, assign) NSString *albumString;

@property(nonatomic, assign) UIViewController *delegate;

@end
