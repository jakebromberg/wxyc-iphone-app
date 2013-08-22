//
//  PlaycutCellShareAction.h
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "Playcut.h"

@protocol PlaycutCellShareAction <NSObject>

+ (void)sharePlaycut:(Playcut *)playcut;

@end
