//
//  DelineationCell.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivePlaylistTableViewCell.h"

@interface DelineationCell : LivePlaylistTableViewCell

- (void) addText:(NSString *) text;
- (id)initWithEntity:(NSManagedObject *)entity;

@end

