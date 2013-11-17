//
//  NSArray+Additions.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/9/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^NSArrayMapBlock) (id obj, NSUInteger idx);
typedef id(^NSArrayFilterBlock) (id obj, NSUInteger, BOOL *stop);

@interface NSArray (Additions)

- (NSString *)join:(NSString *)glue;
- (NSString *)join;

- (instancetype)map:(NSArrayMapBlock)mapBlock;
- (instancetype)filter:(NSArrayFilterBlock)filterBlock;

- (id)objectPassingTest:(BOOL(^)(id obj))test;

@end
