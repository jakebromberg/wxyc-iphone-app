//
//  GoogleImageSearch.h
//  WXYCapp
//
//  Created by Jake on 11/3/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OperationHandler)(NSURL *imageURL, NSError *error);

@interface GoogleImageSearch : NSObject

- (instancetype)initWithKeywords:(NSArray *)keywords completionHandler:(OperationHandler)completionHandler NS_DESIGNATED_INITIALIZER;

- (void)cancel;

@end
