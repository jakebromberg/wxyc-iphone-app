//
//  LivePlaylistTableViewCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LivePlaylistTableViewCell.h"
#import "CALayer+ShadowLayer.h"

@interface LivePlaylistTableViewCell ()

@property (nonatomic, strong) CALayer *shadowLayer;

@end


@interface LivePlaylistTableViewCell ()

@end


@implementation LivePlaylistTableViewCell

+ (float)height
{
	return 44.0f;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.clipsToBounds = NO;
	self.layer.masksToBounds = NO;

    self.containerView.layer.borderColor = [UIColor colorWithWhite:.70f alpha:1.f].CGColor;
    self.containerView.layer.borderWidth = 1.f;
    self.containerView.layer.cornerRadius = 5.f;
    self.containerView.layer.masksToBounds = YES;
	
	self.shadowLayer = [CALayer shadowLayerWithFrame:self.containerView.bounds];
    self.shadowLayer.shadowPath = CGPathCreateWithRoundedRect(self.containerView.frame, 5.f, 5.f, &CGAffineTransformIdentity);
    [self.contentView.layer insertSublayer:self.shadowLayer atIndex:0];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.shadowLayer.shadowPath = CGPathCreateWithRoundedRect(self.containerView.frame, 5.f, 5.f, &CGAffineTransformIdentity);
//    self.shadowLayer.frame = self.bounds;
}

- (id)copyWithZone:(NSZone *)zone
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    NSArray *nibContents = [nib instantiateWithOwner:nil options:nil];
    LivePlaylistTableViewCell *copy = [nibContents firstObject];
    
    copy.entity = self.entity;
    
    return copy;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end
