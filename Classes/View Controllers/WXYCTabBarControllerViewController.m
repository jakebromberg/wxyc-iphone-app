//
//  WXYCTabBarControllerViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 5/25/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "WXYCTabBarControllerViewController.h"

static const UIEdgeInsets insets = (UIEdgeInsets){6, 0, -6, 0};

typedef NS_ENUM(NSUInteger, XYCTabBarItems) {
    XYCLivePlaylistItem,
    XYCFavoritesItem,
    XYCInfoItem
};


@interface WXYCTabBarControllerViewController ()

@property (nonatomic, readonly) UITabBarItem *livePlaylistItem;
@property (nonatomic, readonly) UITabBarItem *favoritesItem;
@property (nonatomic, readonly) UITabBarItem *infoItem;

@end


@implementation WXYCTabBarControllerViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.livePlaylistItem.imageInsets = insets;
    self.livePlaylistItem.image = [[UIImage imageNamed:@"tabbar-item-playlist-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.livePlaylistItem.selectedImage = [[UIImage imageNamed:@"tabbar-item-playlist-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	
	self.favoritesItem.imageInsets = insets;
    self.favoritesItem.image = [[UIImage imageNamed:@"tabbar-item-favorites-unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.favoritesItem.selectedImage = [[UIImage imageNamed:@"tabbar-item-favorites-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    self.infoItem.imageInsets = insets;
    self.infoItem.image = [[UIImage imageNamed:@"tabbar-item-info-unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.infoItem.selectedImage = [[UIImage imageNamed:@"tabbar-item-info-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (UITabBarItem *)livePlaylistItem {
    return self.tabBar.items[XYCLivePlaylistItem];
}

- (UITabBarItem *)favoritesItem {
    return self.tabBar.items[XYCFavoritesItem];
}

- (UITabBarItem *)infoItem {
    return self.tabBar.items[XYCInfoItem];
}

@end
