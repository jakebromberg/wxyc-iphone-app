//
//  NSIndexPath+Additions.h
//  WXYCapp
//
//  Created by Jake Bromberg on 10/19/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (Additions)

+ (NSArray *)indexPathsForItemsInRange:(NSRange)range section:(NSInteger)section;

@end
