//
//  WXYCTabBarControllerViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 5/25/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "WXYCTabBarControllerViewController.h"

static const UIEdgeInsets insets = (UIEdgeInsets){6, 0, -6, 0};

@implementation WXYCTabBarControllerViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UITabBar *tabBar = self.tabBar;
	
	[tabBar.items[0] setImageInsets:insets];
	[tabBar.items[0] setImage:[UIImage imageNamed:@"tabbar-item-playlist-selected.png"]];
	[tabBar.items[0] setSelectedImage:[UIImage imageNamed:@"tabbar-item-playlist-unselected.png"]];
//				  withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-playlist-unselected.png"]];
	
	[tabBar.items[1] setImageInsets:insets];
	[tabBar.items[1] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-favorites-selected.png"]
				  withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-favorites-unselected.png"]];
	
	[tabBar.items[2] setImageInsets:insets];
	[tabBar.items[2] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-info-selected.png"]
				  withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-info-unselected.png"]];
	
	[self setNeedsStatusBarAppearanceUpdate];
}

@end
