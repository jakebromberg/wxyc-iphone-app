//
//  ButtonTableViewCell.h
//  WXYCapp
//
//  Created by Jake on 3/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivePlaylistTableViewCell.h"

@interface LoadPreviousEntriesCell : LivePlaylistTableViewCell

@property (nonatomic, strong) IBOutlet UILabel *description;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;

@end
