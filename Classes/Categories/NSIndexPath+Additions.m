//
//  NSIndexPath+Additions.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/19/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "NSIndexPath+Additions.h"

@implementation NSIndexPath (Additions)

+ (NSArray *)indexPathsForItemsInRange:(NSRange)range section:(NSInteger)section
{
	NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:range.length];
	
	for (NSUInteger i = range.location; i < range.length; i++)
	{
		[indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:section]];
	}
	
	return indexPaths;
}

@end
