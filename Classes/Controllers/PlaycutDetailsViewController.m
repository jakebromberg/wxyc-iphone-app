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
    
    CALayer *outline = [CALayer layer];
    outline.frame = self.view.layer.frame;
    outline.borderColor = [[UIColor lightGrayColor] CGColor];
    outline.borderWidth = 3.f;
    outline.cornerRadius = 6.f;
    [self.view.layer addSublayer:outline];
    
    self.albumImage.image = [UIImage imageWithData:self.playcut.PrimaryImage];
    
    self.prefersStatusBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.albumImage.hidden = NO;
}

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
