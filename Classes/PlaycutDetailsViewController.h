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

@property (nonatomic, strong) Playcut *entity;

@property (nonatomic, strong) IBOutlet UILabel *artist;
@property (nonatomic, strong) IBOutlet UILabel *song;
@property (nonatomic, strong) IBOutlet UILabel *album;
@property (nonatomic, strong) IBOutlet UILabel *label;


@end
