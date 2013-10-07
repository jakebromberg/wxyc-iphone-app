//
//  GoogleImageSearch.h
//  WXYCapp
//
//  Created by Jake on 11/3/10.
//  Copyright 2010 WXYC. All rights reserved.
//

typedef void(^OperationHandler)(NSURL *returnedURL, NSError *message);

@protocol GoogleImageSearchDelegate;


@interface GoogleImageSearch : NSObject

@property (nonatomic, strong) id<GoogleImageSearchDelegate> delegate;

+ (void)searchWithKeywords:(NSArray *)keywords handler:(OperationHandler)operationHandler;

@end
