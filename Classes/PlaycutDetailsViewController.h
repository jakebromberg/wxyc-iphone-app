//
//  PlaycutDetailsViewController.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/11/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playcut.h"

@interface PlaycutDetailsViewController : UIViewController

@property (nonatomic, retain) Playcut *entity;

@property (nonatomic, retain) IBOutlet UILabel *artist;
@property (nonatomic, retain) IBOutlet UILabel *song;
@property (nonatomic, retain) IBOutlet UILabel *album;
@property (nonatomic, retain) IBOutlet UILabel *label;


@end
