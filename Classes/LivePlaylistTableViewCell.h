//
//  LivePlaylistTableViewCell.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol LivePlaylistViewControllerCallback

@property (nonatomic, retain) UITableViewController *delegate;

@end


@interface LivePlaylistTableViewCell : UITableViewCell <LivePlaylistViewControllerCallback>

+ (float)height;
- (id)initWithEntity:(NSManagedObject*)entity;

@property (nonatomic, strong) NSManagedObject *entity;
@property (nonatomic, strong) UITableViewController *delegate;

@end
