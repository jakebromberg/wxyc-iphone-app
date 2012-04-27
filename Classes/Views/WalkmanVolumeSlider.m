//
//  UIWalkmanVolumeSlider.m
//  WXYCapp
//
//  Created by Jake on 10/11/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "WalkmanVolumeSlider.h"

@implementation WalkmanVolumeSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
	return CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetWidth(bounds), 6.0);
}

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
//{
//	return CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetWidth(bounds), CGRectGetHeight(bounds));
//}

- (id)initWithFrame:(CGRect)frame {
	[super initWithFrame:frame];
	[self drawRect:frame];
	return self;
}

- (void)drawRect:(CGRect)rect {
	UIImage *stretchLeftTrack =  [[UIImage imageNamed:@"total track image.png"]
								  stretchableImageWithLeftCapWidth:20.0 topCapHeight:0];

	UIImage *stretchRightTrack = [[UIImage imageNamed:@"total track image.png"]
								  stretchableImageWithLeftCapWidth:20.0 topCapHeight:0];

	UIImage *thumb = [UIImage imageNamed:@"thumb image.png"];

}

- (void)dealloc {
    [super dealloc];
}


@end
