//
//  FacebookShareButton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "FacebookShareButton.h"
#import <Social/Social.h>
#import "UIButton+PlaycutCell.h"
#import "NSString+Additions.h"
#import "FacebookShareAction.h"

@implementation FacebookShareButton (PlaycutCell)

- (Class<PlaycutCellShareAction>)playcutCellShareAction
{
	return [FacebookShareAction class];
}

@end
