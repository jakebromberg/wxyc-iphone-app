//
//  LivePlaylistTableViewCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LivePlaylistTableViewCell.h"
#import "NSObject+KVOBlocks.h"

@interface LivePlaylistTableViewCell ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) CALayer *shadowLayer;

@end

@implementation LivePlaylistTableViewCell

+ (float)height
{
	return 44.0f;
}

- (void)awakeFromNib
{
	self.clipsToBounds = NO;
	self.layer.masksToBounds = NO;
	
	self.containerView.layer.borderColor = [UIColor colorWithWhite:.70f alpha:1.f].CGColor;
	self.containerView.layer.borderWidth = 1.f;
	self.containerView.layer.cornerRadius = 5.f;
	self.containerView.layer.masksToBounds = YES;

	[self.layer insertSublayer:self.shadowLayer atIndex:0];
	
	[self observeKeyPath:@keypath(self.containerView, frame) changeBlock:^(id change) {
		self.containerView.frame = _containerView.frame;
		self.shadowLayer.frame = _containerView.frame;
		[self.containerView setNeedsDisplay];
	}];
}

- (CALayer *)shadowLayer
{
	CALayer *shadowLayer = [CALayer layer];
	shadowLayer.frame = self.containerView.frame;
	shadowLayer.backgroundColor = [UIColor clearColor].CGColor;
	shadowLayer.shadowColor = [UIColor colorWithWhite:.75f alpha:1.f].CGColor;
	shadowLayer.shadowOffset = (CGSize){-.5f, 1.f};
	shadowLayer.shadowRadius = 1.5f;
	shadowLayer.shadowOpacity = 1;
	shadowLayer.shadowPath = CGPathCreateWithRoundedRect(self.containerView.bounds, 5.f, 5.f, &CGAffineTransformIdentity);
	shadowLayer.cornerRadius = 5.f;
	shadowLayer.masksToBounds = NO;
	shadowLayer.shouldRasterize = YES;
	shadowLayer.rasterizationScale = [UIScreen mainScreen].scale;

	return shadowLayer;
}

@end
