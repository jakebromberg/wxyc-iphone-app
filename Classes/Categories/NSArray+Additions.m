//
//  NSArray+Additions.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/9/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSString *)join:(NSString *)glue
{
	return [self componentsJoinedByString:glue];
}

- (NSString *)join
{
	return [self join:@""];
}

- (instancetype)map:(NSArrayMapBlock)mapBlock
{
	NSMutableArray *mappedArray = [self mutableCopy];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[mappedArray addObject:mapBlock(obj, obj)];
	}];
	
	return mappedArray;
}

- (instancetype)filter:(NSArrayFilterBlock)filterBlock
{
	NSMutableArray *filteredArray = [NSMutableArray array];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		BOOL passesTest = filterBlock(obj, idx, stop);
		
		if (passesTest) {
			[filteredArray addObject:obj];
		}
	}];
	
	return filteredArray;
}

- (id)objectPassingTest:(BOOL(^)(id obj))test
{
	NSUInteger idx = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return test(obj);
	}];
	
	if (idx == NSNotFound)
		return nil;
	else
		return [self objectAtIndex:idx];
}

@end
