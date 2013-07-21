//
//  SocialShareAction.h
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaycutCellShareAction.h"
#import <Social/Social.h>
#include "Singleton.h"

@interface SocialShareAction : NSObject<PlaycutCellShareAction>

+ (NSString *)SLServiceType;
+ (NSString *)serviceName;

@end
