//
//  LivePlaylistTransitionSnaphot.h
//  WXYCapp
//
//  Created by Jake on 1/21/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivePlaylistTableViewController.h"
#import "PlaycutCell.h"

@interface LivePlaylistTransitionSnaphot : NSObject

- (instancetype)initWithViewController:(LivePlaylistTableViewController *)viewController selectedCell:(PlaycutCell *)cell;

@property (nonatomic, strong, readonly) UIView *statusBar;
@property (nonatomic, strong, readonly) UIView *navigationBar;
@property (nonatomic, strong, readonly) UIView *tableBackground;
@property (nonatomic, strong, readonly) PlaycutCell *cellSnapshot;
@property (nonatomic, strong, readonly) UIView *tabBar;

@end
