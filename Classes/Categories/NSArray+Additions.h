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

- (NSArray *)map:(NSArrayMapBlock)mapBlock;
- (NSArray *)filter:(BOOL(^)(id obj, NSUInteger idx, BOOL *stop))filterBlock;

- (id)objectPassingTest:(BOOL(^)(id obj))test;
- (NSArray *)objectsPassingTest:(BOOL(^)(id obj))test;

@end
