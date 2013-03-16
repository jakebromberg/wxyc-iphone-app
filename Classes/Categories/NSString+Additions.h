//
//  NSString+Additions.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/9/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (instancetype)append:(NSString *)string;
- (NSString*)formattedWith:(NSArray*)arguments;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end
