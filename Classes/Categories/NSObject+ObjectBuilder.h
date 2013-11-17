//
//  NSObject+ObjectBuilder.h
//  WXYCapp
//
//  Created by Jake Bromberg on 10/23/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ObjectBuilder)

- (instancetype)initWithPropertyDictionary:(NSDictionary *)dictionary;

@end
