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
	UIView *__weak accessoryView;

	NSString *__weak artistString;
	NSString *__weak titleString;
	NSString *__weak albumString;
	
	MBProgressHUD *HUD;
}

@property (nonatomic, strong) IBOutlet UITextView *myTextView;
@property (nonatomic, weak) IBOutlet UIView *accessoryView;

@property (nonatomic, weak) IBOutlet UIButton *artistButton;
@property (nonatomic, weak) IBOutlet UIButton *titleButton;
@property (nonatomic, weak) IBOutlet UIButton *albumButton;
@property (nonatomic, weak) IBOutlet UIButton *wxycButton;
@property (nonatomic, weak) IBOutlet UILabel *charCountLabel; //TODO: move this to the twitter share class

@property (nonatomic, weak) NSString *artistString;
@property (nonatomic, weak) NSString *titleString;
@property (nonatomic, weak) NSString *albumString;

@property(nonatomic, weak) UIViewController *delegate;

@end
