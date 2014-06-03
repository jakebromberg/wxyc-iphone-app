//
//  UIView+Spin.m
//  WXYCapp
//
//  Created by Jake Bromberg on 9/13/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "UIView+Spin.h"
#import "IndefinitelySpinningAnimation.h"

static NSString * const kSpinKey = @"spinAnimation";

@implementation UIView (Spin)

- (void)startSpin
{
	if (![self.layer animationForKey:kSpinKey])
	{
		[self.layer addAnimation:[IndefinitelySpinningAnimation animation] forKey:kSpinKey];
		[self pauseLayer:self.layer];
	}
	
	[self resumeLayer:self.layer];
}

- (void)stopSpin
{
	[self pauseLayer:self.layer];
}

#pragma mark Core Animation business

- (void)pauseLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
	
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

@end
