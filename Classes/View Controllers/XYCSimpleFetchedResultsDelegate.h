//
//  XYCSimpleFetchedResultsDelegate.h
//  WXYCapp
//
//  Created by Jake Bromberg on 1/31/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYCSimpleFetchedResultsDelegate : NSObject <NSFetchedResultsControllerDelegate>

- (instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, strong, readonly) UITableView *tableView;

@end
