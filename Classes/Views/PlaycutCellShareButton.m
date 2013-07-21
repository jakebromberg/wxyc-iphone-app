//
//  PlaycutCellShareButton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "PlaycutCellShareButton.h"
#import "UIButton+PlaycutCell.h"

@implementation PlaycutCellShareButton

@synthesize playcut;
@dynamic playcutCellShareAction;

- (void)touchUpInsideHandler:(id)sender
{
	[self.playcutCellShareAction sharePlaycut:self.playcut];
}

@end
