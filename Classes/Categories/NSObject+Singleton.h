//
//  NSObject+Singleton.h
//  WXYCapp
//
//  Created by Jake Bromberg on 10/9/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XYCSingleton <NSObject>

@required

+ (instancetype)sharedObject;

@end


@interface NSObject (Singleton) <XYCSingleton>

+ (instancetype)sharedObject;

@end
