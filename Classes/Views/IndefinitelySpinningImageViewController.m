//
//  IndefinitelySpinningImageViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/10/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "IndefinitelySpinningImageViewController.h"
#import "IndefinitelySpinningAnimation.h"

@implementation IndefinitelySpinningImageViewController

#pragma mark initialization stuff

- (void)initImageViewAnimation
{
	[self.imageView.layer addAnimation:[IndefinitelySpinningAnimation getAnimation] forKey:@"spinAnimation"];
	[self pauseLayer:self.imageView.layer];
}

- (id)initWithImageView:(UIImageView*)imageView
{
	self = [super init];
	self.imageView = imageView;
	[self initImageViewAnimation];
	
	return self;
}

#pragma mark Public Methods

- (void)animate:(BOOL)state
{
	if (state)
		[self startAnimation];
	else
		[self stopAnimation];
}

- (void)startAnimation
{
	[self resumeLayer:self.imageView.layer];
}

- (void)stopAnimation
{
	[self pauseLayer:self.imageView.layer];
}

- (void)setImageView:(UIImageView *)imageView
{
	_imageView = imageView;
	[self initImageViewAnimation];
}

#pragma mark Core Animation business

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
	
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end
