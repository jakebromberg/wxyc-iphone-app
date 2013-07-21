//
//  PlaycutCellButton.h
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaycutCellShareAction.h"

@protocol PlaycutCellButton <NSObject>

- (instancetype)initWithPlaycut:(Playcut *)playcut;

@property (nonatomic, strong) Playcut *playcut;
@property (nonatomic, readonly) Class<PlaycutCellShareAction> playcutCellShareAction;

@end
