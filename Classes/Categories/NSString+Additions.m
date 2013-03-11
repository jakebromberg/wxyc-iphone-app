//
//  NSString+Additions.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/9/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (instancetype)append:(NSString *)string
{
	return [self stringByAppendingString:string];
}

- (NSString*)formattedWith:(NSArray*)arguments
{
	NSRange range = NSMakeRange(0, arguments.count);
	NSMutableData* data = [NSMutableData dataWithLength:sizeof(id) * arguments.count];
	[arguments getObjects:(__unsafe_unretained id *)data.mutableBytes range:range];
	
	return [[NSString alloc] initWithFormat:self arguments:data.mutableBytes];
}

@end
