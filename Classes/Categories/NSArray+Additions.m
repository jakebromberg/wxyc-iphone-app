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
	NSMutableArray *mappedArray = [NSMutableArray array];
	
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[mappedArray addObject:mapBlock(obj, idx)];
	}];
	
	return mappedArray;
}

- (instancetype)filter:(BOOL(^)(id obj, NSUInteger, BOOL *stop))filterBlock
{
	NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:filterBlock];
	return [self objectsAtIndexes:indexSet];
}

- (id)objectPassingTest:(BOOL(^)(id obj))test
{
	NSUInteger idx = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return test(obj);
	}];
	
	if (idx == NSNotFound)
		return nil;
	else
		return self[idx];
}

@end
