//
//  IndefinitelySpinningAnimation.m
//  WXYCapp
//
//  Created by Jake Bromberg on 6/27/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "IndefinitelySpinningAnimation.h"

@implementation IndefinitelySpinningAnimation

+ (instancetype)animation
{
	IndefinitelySpinningAnimation *spinAnimation;

	spinAnimation = [self animationWithKeyPath:@"transform.rotation.z"];
	spinAnimation.duration = 2;
	spinAnimation.repeatCount = FLT_MAX;
	spinAnimation.autoreverses = NO;
	spinAnimation.fromValue = @(M_PI / 3);
	spinAnimation.toValue = @0.0f;
	spinAnimation.removedOnCompletion = NO;
	
	return spinAnimation;
}

@end
