//
//  PlaylistMapping.h
//  WXYCapp
//
//  Created by Jake Bromberg on 4/15/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Singleton.h"
#import <RestKit/RestKit.h>

@interface PlaylistMapping : NSObject <XYCSingleton>

@property (nonatomic, strong) RKObjectManager* objectManager;

@end