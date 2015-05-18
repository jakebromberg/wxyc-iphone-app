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

@implementation LivePlaylistTableViewCell

- (void)awakeFromNib
{
	self.clipsToBounds = NO;
	self.layer.masksToBounds = NO;

    self.containerView.layer.borderColor = [UIColor colorWithWhite:.70f alpha:1.f].CGColor;
    self.containerView.layer.borderWidth = 1.f;
    self.containerView.layer.cornerRadius = 5.f;
    self.containerView.layer.masksToBounds = YES;
    
    [self.contentView.layer insertSublayer:self.shadowLayer atIndex:0];

	__weak __typeof(self) welf = self;
	[self observeKeyPath:@keypath(self.containerView.layer, frame) changeBlock:^(NSDictionary *change) {
		welf.shadowLayer.shadowPath = CGPathCreateWithRoundedRect(welf.containerView.frame, 5.f, 5.f, &CGAffineTransformIdentity);
	}];
}

- (CALayer *)shadowLayer
{
    if (!_shadowLayer)
    {
        _shadowLayer = [CALayer layer];
        _shadowLayer.frame = self.containerView.bounds;
        _shadowLayer.backgroundColor = [UIColor clearColor].CGColor;
        _shadowLayer.shadowColor = [UIColor colorWithWhite:.75f alpha:1.f].CGColor;
        _shadowLayer.shadowOffset = (CGSize){-.5f, 1.f};
        _shadowLayer.shadowRadius = 1.5f;
        _shadowLayer.shadowOpacity = 1;
        _shadowLayer.shadowPath = CGPathCreateWithRoundedRect(self.containerView.bounds, 5.f, 5.f, &CGAffineTransformIdentity);
        _shadowLayer.masksToBounds = NO;
        _shadowLayer.shouldRasterize = YES;
        _shadowLayer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    
	return _shadowLayer;
}

- (id)copyWithZone:(NSZone *)zone
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    NSArray *nibContents = [nib instantiateWithOwner:nil options:nil];
    LivePlaylistTableViewCell *copy = [nibContents firstObject];
    
    copy.entity = self.entity;
    
    return copy;
}

@end
