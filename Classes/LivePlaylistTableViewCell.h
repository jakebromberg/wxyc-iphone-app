//
//  LivePlaylistTableViewCell.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "PlaylistEntry.h"

@interface LivePlaylistTableViewCell : UITableViewCell <NSCopying>

@property (nonatomic, strong) PlaylistEntry *entity;

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) CALayer *shadowLayer;

@end
