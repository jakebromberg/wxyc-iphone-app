//
//  XYCSimpleTableViewDelegate.h
//  WXYCapp
//
//  Created by Jake Bromberg on 1/31/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivePlaylistTableViewController.h"
#import "PlaylistEntry.h"

@interface XYCLivePlaylistDelegate : NSObject <XYCSimpleTableViewDelegate>

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController<PlaylistEntry *> *)fetchedResultsController;

@property (nonatomic, strong) NSFetchedResultsController<PlaylistEntry *> *fetchedResultsController;
@property (nonatomic, weak) UIViewController *presentingViewController;

@end
