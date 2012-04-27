//
//  ButtonTableViewCell.h
//  WXYCapp
//
//  Created by Jake on 3/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivePlaylistTableViewCell.h"

@interface LoadPreviousEntriesCell : LivePlaylistTableViewCell {
	IBOutlet UILabel *description;
	IBOutlet UIActivityIndicatorView *activity;
}

@property (nonatomic, retain) IBOutlet UILabel *description;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

@end
