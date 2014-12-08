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
    
    [self.contentView.layer insertSublayer:self.shadowLayer atIndex:0];

    [self observeKeyPath:@keypath(self.containerView.layer, frame) changeBlock:^(NSDictionary *change) {
        _shadowLayer.shadowPath = CGPathCreateWithRoundedRect(self.containerView.frame, 5.f, 5.f, &CGAffineTransformIdentity);
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

@end
