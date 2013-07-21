//
//  SearchButton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/21/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "SearchButton.h"
#import "SearchAction.h"

@implementation SearchButton

- (Class<PlaycutCellShareAction>)playcutCellShareAction
{
	return [SearchAction class];
}

@end
