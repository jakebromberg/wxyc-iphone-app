//
//  SearchShareButton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/15/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "SearchShareButton.h"
#import "SearchShareAction.h"

@implementation SearchShareButton

- (Class<PlaycutCellShareAction>)playcutCellShareAction
{
	return [SearchShareAction class];
}

@end
