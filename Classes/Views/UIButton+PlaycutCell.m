//
//  UIButton+PlaycutCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "UIButton+PlaycutCell.h"

@implementation UIButton (PlaycutCell)

@dynamic playcut;
@dynamic playcutCellShareAction;

- (IBAction)touchUpInsideHandler:(id)sender
{
	[self.playcutCellShareAction sharePlaycut:self.playcut];
}

- (instancetype)initWithPlaycut:(Playcut *)playcut
{
	self = [super init];
	
	if (!self)
	{
		self.playcut = playcut;
	}
	
	return self;
}

@end
