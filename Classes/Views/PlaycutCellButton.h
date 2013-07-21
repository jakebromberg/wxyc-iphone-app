//
//  PlaycutCellButton.h
//  WXYCapp
//
//  Created by Jake Bromberg on 7/20/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaycutCellShareAction.h"

@interface PlaycutCellButton : UIButton

@property (nonatomic, strong) Playcut *playcut;
@property (nonatomic, readonly) Class<PlaycutCellShareAction> playcutCellShareAction;

@end
