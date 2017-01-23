//
//  XYCDataStack.h
//  WXYCapp
//
//  Created by Jake Bromberg on 10/13/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Singleton.h"

// TODO: use this
@protocol XYCDataStackDescriptor <NSObject>

- (NSURL *)baseURL CA_CONST;
- (NSURL *)managedObjectModelURL CA_CONST;
- (NSString *)managedObjectStoreURL CA_CONST;

@end

@interface XYCDataStack : NSObject <XYCSingleton>

@end
