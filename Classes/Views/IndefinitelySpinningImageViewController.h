//
//  IndefinitelySpinningImageViewController.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/10/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface IndefinitelySpinningImageViewController : UIViewController

- (IndefinitelySpinningImageViewController*)initWithImageView:(UIImageView*)imageView;

- (void)animate:(BOOL)state;
- (void)startAnimation;
- (void)stopAnimation;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end
