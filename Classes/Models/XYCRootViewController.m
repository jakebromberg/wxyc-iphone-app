//
//  XYCRootViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/7/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "XYCRootViewController.h"
#import "AudioStreamController.h"

@interface XYCRootViewController ()

@end

@implementation XYCRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIView *navView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationBarTitle" owner:self options:nil] lastObject];
	[self.navigationBar insertSubview:navView atIndex:self.navigationBar.subviews.count];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleBlackOpaque;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
	if ((receivedEvent.type != UIEventTypeRemoteControl) ||
		(receivedEvent.subtype != UIEventSubtypeRemoteControlTogglePlayPause))
		return;
	
	if ([AudioStreamController wxyc].isPlaying)
		[[AudioStreamController wxyc] stop];
	else
		[[AudioStreamController wxyc] start];
}

@end
