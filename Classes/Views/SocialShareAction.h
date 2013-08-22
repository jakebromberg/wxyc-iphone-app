//
//  SocialShareAction.h
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "PlaycutCellShareAction.h"
#import <Social/Social.h>

@interface SocialShareAction : NSObject<PlaycutCellShareAction>

+ (NSString *)SLServiceType;
+ (NSString *)serviceName;

@end
