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

@property  (nonatomic, weak) IBOutlet UIView *containerView;
@property  (nonatomic, strong) UIView *shadowView;

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

	[self insertSubview:self.shadowView belowSubview:self.containerView];
	
	[self observeKeyPath:@keypath(self.containerView, frame) changeBlock:^(id change) {
		_shadowView.frame = _containerView.frame;
	}];
}

- (UIView *)shadowView
{
	if (!_shadowView)
	{
		_shadowView = [[UIView alloc] initWithFrame:self.containerView.frame];
		_shadowView.backgroundColor = [UIColor grayColor];
		_shadowView.layer.shadowColor = [UIColor colorWithWhite:.75f alpha:1.f].CGColor;
		_shadowView.layer.shadowOffset = (CGSize){-.5f, 1.f};
		_shadowView.layer.shadowRadius = 1.5f;
		_shadowView.layer.shadowOpacity = 1;
		_shadowView.layer.cornerRadius = 5.f;
		_shadowView.layer.masksToBounds = NO;
		_shadowView.layer.shouldRasterize = YES;
		_shadowView.layer.rasterizationScale = [UIScreen mainScreen].scale;
	}
	
	return _shadowView;
}

- (void)dealloc
{
	_shadowView = nil;
}

@end
