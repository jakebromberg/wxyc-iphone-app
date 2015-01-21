//
//  PlaycutDetailsViewController.h
//  WXYCapp
//
//  Created by Jake on 1/17/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "Playcut.h"

@interface PlaycutDetailsViewController : UIViewController

@property (nonatomic, strong) Playcut *playcut;
@property (nonatomic, weak, readonly) UIImageView *albumImage;

@end
