//
//  LivePlaylistTableViewCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LivePlaylistTableViewCell.h"

@interface LivePlaylistTableViewCell ()

@property  (nonatomic, weak) IBOutlet UIView *containerView;
@property  (nonatomic, weak) IBOutlet UIView *shadowView;

@end

@implementation LivePlaylistTableViewCell

- (void)awakeFromNib
{
	self.containerView.layer.borderColor = [UIColor colorWithWhite:.70f alpha:1.f].CGColor;
	self.containerView.layer.borderWidth = 1.f;
	self.containerView.layer.cornerRadius = 5.f;
	
	self.shadowView.layer.shadowColor = [UIColor colorWithWhite:.75f alpha:1.f].CGColor;
	self.shadowView.layer.shadowOffset = CGSizeMake(0.f, 1.f);
	self.shadowView.layer.shadowRadius = 1.5f;
	self.shadowView.layer.shadowOpacity = 1;
	self.shadowView.layer.cornerRadius = 5.f;
	self.shadowView.layer.shouldRasterize = YES;
	self.shadowView.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

+ (float)height
{
	return 44.0f;
}

- (id)initWithEntity:(NSManagedObject *)entity
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end