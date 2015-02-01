//
//  XYCFavoritesDelegate.h
//  WXYCapp
//
//  Created by Jake Bromberg on 1/31/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LivePlaylistTableViewController.h"

@interface XYCFavoritesDelegate : NSObject <XYCSimpleTableViewDelegate>

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
