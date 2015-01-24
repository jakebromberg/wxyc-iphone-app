//
//  LivePlaylistTransitionSnaphot.m
//  WXYCapp
//
//  Created by Jake on 1/21/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "LivePlaylistTransitionSnaphot.h"
#import "XYCRootViewController.h"
#import "NSArray+Additions.h"
#import "LivePlaylistTableViewCell.h"

@implementation LivePlaylistTransitionSnaphot

- (instancetype)initWithViewController:(LivePlaylistTableViewController *)viewController selectedCell:(PlaycutCell *)cell
{
    if (!(self = [super init])) return nil;
    
    _statusBar = [self snapshotStatusBar:viewController];
    _navigationBar = [self snapshotNavBar:viewController];
    _tableBackground = [self snapshotTableView:viewController excludingCell:cell];
    _tabBar = [self snaphotTabBar:viewController];
    
    return self;
}

- (UIView *)snapshotStatusBar:(UIViewController *)viewController
{
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    UIWindow *window = viewController.view.window;
    
    return [window resizableSnapshotViewFromRect:statusBarFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
}

- (UIView *)snapshotNavBar:(UIViewController *)viewController
{
    XYCRootViewController *fromVC = (XYCRootViewController *) viewController.parentViewController.parentViewController;
    UIView *snapshot = [fromVC.navigationBar snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = (CGRect) {
        .origin = [fromVC.navigationBar.window convertPoint:fromVC.navigationBar.frame.origin fromView:fromVC.view],
        .size = snapshot.frame.size,
    };

    return snapshot;
}

- (UIView *)snapshotTableView:(UITableViewController *)tableViewController excludingCell:(PlaycutCell *)playcutCell
{
    
    
    NSArray *visibleCells = [[tableViewController.tableView.visibleCells filter:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return obj != playcutCell;
    }] map:^id(LivePlaylistTableViewCell *cell, NSUInteger idx) {
        return [cell copy];
    }];
    
    NSLog(@"%@", visibleCells);
    
    NSData *tempArchiveView = [NSKeyedArchiver archivedDataWithRootObject:tableViewController.view];
    UITableView *tableView = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
    
    tableView.clipsToBounds = NO;
    [tableView insertSubview:({
        UIView *backgroundView = [[UIView alloc] initWithFrame:tableView.window.frame];
        backgroundView.backgroundColor = tableView.backgroundColor;
        backgroundView;
    }) atIndex:tableView.subviews.count];

    return tableView;
}

- (UIView *)snaphotTabBar:(UIViewController *)viewController
{
    return nil;
}

@end
