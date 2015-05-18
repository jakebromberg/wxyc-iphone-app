//
//  CALayer+ShadowLayer.m
//  WXYCapp
//
//  Created by Jake Bromberg on 5/18/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "CALayer+ShadowLayer.h"

@implementation CALayer (ShadowLayer)

+ (CALayer *)shadowLayerWithFrame:(CGRect)frame
{
	CALayer *shadowLayer = [CALayer layer];
	
	shadowLayer.frame = frame;
	shadowLayer.backgroundColor = [UIColor clearColor].CGColor;
	shadowLayer.shadowColor = [UIColor colorWithWhite:.75f alpha:1.f].CGColor;
	shadowLayer.shadowOffset = (CGSize){-.5f, 1.f};
	shadowLayer.shadowRadius = 1.5f;
	shadowLayer.shadowOpacity = 1;
	shadowLayer.shadowPath = CGPathCreateWithRoundedRect(frame, 5.f, 5.f, &CGAffineTransformIdentity);
	shadowLayer.masksToBounds = NO;
	shadowLayer.shouldRasterize = YES;
	shadowLayer.rasterizationScale = [UIScreen mainScreen].scale;

	return shadowLayer;
}

@end
