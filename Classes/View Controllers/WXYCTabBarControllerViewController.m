//
//  WXYCTabBarControllerViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 5/25/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "WXYCTabBarControllerViewController.h"
#import "LivePlaylistTableViewController.h"
#import "FavoritesTableViewController.h"
#import "NSFetchedResultsController+XYCViewControllers.h"
#import "XYCLivePlaylistDelegate.h"
#import "XYCSimpleFetchedResultsDelegate.h"

static const UIEdgeInsets insets = (UIEdgeInsets) {6, 0, -6, 0};

typedef NS_ENUM(NSUInteger, XYCTabBarItems) {
    XYCLivePlaylistItem,
    XYCFavoritesItem,
    XYCInfoItem
};


@interface WXYCTabBarControllerViewController ()

@property (nonatomic, readonly) UITabBarItem *livePlaylistItem;
@property (nonatomic, readonly) UITabBarItem *favoritesItem;
@property (nonatomic, readonly) UITabBarItem *infoItem;


@property (nonatomic, readonly) LivePlaylistTableViewController *livePlaylistTableViewController;
@property (nonatomic, strong) id<XYCSimpleTableViewDelegate> livePlaylistTableViewDelegate;
@property (nonatomic, strong) id<NSFetchedResultsControllerDelegate> livePlaylistFetchedResultsDelegate;

@property (nonatomic, readonly) FavoritesTableViewController *favoritesTableViewController;
@property (nonatomic, strong) id<XYCSimpleTableViewDelegate> favoritesTableViewDelegate;
@property (nonatomic, strong) id<NSFetchedResultsControllerDelegate> favoritesFetchedResultsDelegate;

@end


@implementation WXYCTabBarControllerViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.livePlaylistItem.imageInsets = insets;
    self.livePlaylistItem.image = [[UIImage imageNamed:@"tabbar-item-playlist-unselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.livePlaylistItem.selectedImage = [[UIImage imageNamed:@"tabbar-item-playlist-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	
	self.favoritesItem.imageInsets = insets;
    self.favoritesItem.image = [[UIImage imageNamed:@"tabbar-item-favorites-unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.favoritesItem.selectedImage = [[UIImage imageNamed:@"tabbar-item-favorites-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    self.infoItem.imageInsets = insets;
    self.infoItem.image = [[UIImage imageNamed:@"tabbar-item-info-unselected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.infoItem.selectedImage = [[UIImage imageNamed:@"tabbar-item-info-selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	
//	[self setUpLivePlaylistViewController];
//	[self setUpFavoritesViewController];
}

- (void)setUpLivePlaylistViewController
{
	NSFetchedResultsController *livePlaylistFetchedResultsController = [NSFetchedResultsController livePlaylistFetchedResultsController];
	self.livePlaylistFetchedResultsDelegate = [[XYCSimpleFetchedResultsDelegate alloc] initWithTableView:self.livePlaylistTableViewController.tableView];
	livePlaylistFetchedResultsController.delegate = self.livePlaylistFetchedResultsDelegate;
	
	self.livePlaylistTableViewDelegate = [[XYCLivePlaylistDelegate alloc] initWithFetchedResultsController:livePlaylistFetchedResultsController];
	self.livePlaylistTableViewController.tableView.delegate = self.livePlaylistTableViewDelegate;
	self.livePlaylistTableViewController.tableView.dataSource = self.livePlaylistTableViewDelegate;
	[self.livePlaylistTableViewController.tableView reloadData];
}

- (void)setUpFavoritesViewController
{
	NSFetchedResultsController *livePlaylistFetchedResultsController = [NSFetchedResultsController favoritesFetchedResultsController];
	self.favoritesFetchedResultsDelegate = [[XYCSimpleFetchedResultsDelegate alloc] initWithTableView:self.favoritesTableViewController.tableView];
	livePlaylistFetchedResultsController.delegate = self.favoritesFetchedResultsDelegate;
	
	self.favoritesTableViewDelegate = [[XYCLivePlaylistDelegate alloc] initWithFetchedResultsController:livePlaylistFetchedResultsController];
	self.favoritesTableViewController.tableView.delegate = self.favoritesTableViewDelegate;
	self.favoritesTableViewController.tableView.dataSource = self.favoritesTableViewDelegate;
	[self.favoritesTableViewController.tableView reloadData];
}

- (UITabBarItem *)livePlaylistItem
{
    return self.tabBar.items[XYCLivePlaylistItem];
}

- (UITabBarItem *)favoritesItem
{
    return self.tabBar.items[XYCFavoritesItem];
}

- (UITabBarItem *)infoItem
{
    return self.tabBar.items[XYCInfoItem];
}

- (LivePlaylistTableViewController *)livePlaylistTableViewController
{
	return self.viewControllers[XYCLivePlaylistItem];
}

- (FavoritesTableViewController *)favoritesTableViewController
{
	return self.viewControllers[XYCFavoritesItem];
}

@end
