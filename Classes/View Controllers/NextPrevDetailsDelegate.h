//
//  NextPrevDetailsDelegate.h
//  WXYCapp
//
//  Created by Jake on 11/15/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NextPrevDetailsDelegate

@required
-(id)NPnext;
-(id)NPprev;
-(id)NPcurrent;
-(BOOL)hasNext;
-(BOOL)hasPrev;

@end
