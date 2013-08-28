//
//  TwitterShareButton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/21/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "TwitterShareButton.h"
#import "TwitterShareAction.h"

@implementation TwitterShareButton

- (Class<PlaycutCellShareAction>)playcutCellShareAction
{
	return [TwitterShareAction class];
}

@end