//
//  LivePlaylistTableViewCell.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

@interface LivePlaylistTableViewCell : UITableViewCell

+ (float)height;

@property (nonatomic, strong) NSManagedObject *entity;

@end
