//
//  PlaycutDetailsViewController.m
//  WXYCapp
//
//  Created by Jake on 1/17/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "PlaycutDetailsViewController.h"

@interface PlaycutDetailsViewController ()

@property (nonatomic, weak, readwrite) IBOutlet UIImageView *albumImage;

@end


@implementation PlaycutDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.view.layer.borderWidth = 3.f;
    self.view.layer.cornerRadius = 3.f;
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
