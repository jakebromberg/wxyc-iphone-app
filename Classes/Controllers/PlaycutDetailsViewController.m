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

@property (nonatomic, assign) BOOL prefersStatusBarHidden;

@end


@implementation PlaycutDetailsViewController

@synthesize prefersStatusBarHidden = _prefersStatusBarHidden;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.view.layer.borderWidth = 3.f;
    self.view.layer.cornerRadius = 3.f;
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.prefersStatusBarHidden = YES;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    self.prefersStatusBarHidden = YES;
//}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    self.prefersStatusBarHidden = YES;
//}

- (void)setPrefersStatusBarHidden:(BOOL)prefersStatusBarHidden
{
    if (_prefersStatusBarHidden == prefersStatusBarHidden)
        return;
    
    _prefersStatusBarHidden = prefersStatusBarHidden;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
    return _prefersStatusBarHidden;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
