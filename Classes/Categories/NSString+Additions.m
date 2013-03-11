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

//- (NSString *)formattedWith:(NSArray *)strings
//{
//	id arrayObjects[strings.count];
//	
//	for (int i=0; i<strings.count; i++) {
//		arrayObjects[i] = strings[i];
//	}
//
//	return [[NSString alloc] initWithFormat:self arguments:(va_list)arrayObjects];
//}

@end
