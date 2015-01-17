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

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	UITabBar *tabBar = self.tabBar;
	
	[tabBar.items[0] setImageInsets:insets];
    [tabBar.items[0] setImage:[[UIImage imageNamed:@"tabbar-item-playlist-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBar.items[0] setSelectedImage:[[UIImage imageNamed:@"tabbar-item-playlist-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
	
	[tabBar.items[1] setImageInsets:insets];
    [tabBar.items[1] setImage:[[UIImage imageNamed:@"tabbar-item-favorites-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBar.items[1] setSelectedImage:[[UIImage imageNamed:@"tabbar-item-favorites-unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
	
	[tabBar.items[2] setImageInsets:insets];
    [tabBar.items[2] setImage:[[UIImage imageNamed:@"tabbar-item-info-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBar.items[2] setSelectedImage:[[UIImage imageNamed:@"tabbar-item-info-unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

@end
