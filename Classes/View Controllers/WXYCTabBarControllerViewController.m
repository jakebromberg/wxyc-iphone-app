//
//  WXYCTabBarControllerViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 5/25/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "WXYCTabBarControllerViewController.h"

@implementation WXYCTabBarControllerViewController

- (void)viewDidLoad
{
	UITabBar *tabBar = self.tabBar;
	
	[tabBar.items[0] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
	[tabBar.items[0] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-playlist-selected.png"]
				  withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-playlist-unselected.png"]];
	
	[tabBar.items[1] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
	[tabBar.items[1] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-favorites-selected.png"]
				  withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-favorites-unselected.png"]];
	
	[tabBar.items[2] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
	[tabBar.items[2] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-info-selected.png"]
				  withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-info-unselected.png"]];
}

@end
