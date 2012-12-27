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

- (id)initWithFrame:(CGRect)frame {
	if (!(self = [super initWithFrame:frame]))
		return nil;
	
	[self drawRect:frame];
	
	return self;
}

- (void)drawRect:(CGRect)rect {
	UIImage *stretchLeftTrack =  [[UIImage imageNamed:@"total track image.png"]
								  stretchableImageWithLeftCapWidth:20.0 topCapHeight:0];

	UIImage *stretchRightTrack = [[UIImage imageNamed:@"total track image.png"]
								  stretchableImageWithLeftCapWidth:20.0 topCapHeight:0];

	UIImage *thumb = [UIImage imageNamed:@"thumb image.png"];

	[self setVolumeThumbImage:thumb forState:UIControlStateNormal];
	[self setMinimumVolumeSliderImage:stretchLeftTrack forState:UIControlStateNormal];
	[self setMaximumVolumeSliderImage:stretchRightTrack forState:UIControlStateNormal];
//	[self setMinimumTrackImage:stretchLeftTrack forState:UIControlStateNormal];
//	[self setMaximumTrackImage:stretchRightTrack forState:UIControlStateNormal];
//	
//	[self setThumbImage:thumb forState:UIControlStateNormal];
//	[self setThumbImage:thumb forState:UIControlStateHighlighted];
//	[self setThumbImage:thumb forState:UIControlStateDisabled];
}



@end
