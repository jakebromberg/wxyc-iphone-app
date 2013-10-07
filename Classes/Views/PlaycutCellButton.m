//
//  PlaycutCellButton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 9/22/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "PlaycutCellButton.h"

@implementation PlaycutCellButton

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (event.type == UIEventTypeTouches)
	{
		[self.playcutCellShareAction sharePlaycut:self.playcut];
	}
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
