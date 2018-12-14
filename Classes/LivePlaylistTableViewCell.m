//
//  LivePlaylistTableViewCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LivePlaylistTableViewCell.h"

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
	
    [self layoutIfNeeded];
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
