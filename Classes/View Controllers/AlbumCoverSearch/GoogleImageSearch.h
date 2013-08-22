//
//  GoogleImageSearch.h
//  WXYCapp
//
//  Created by Jake on 11/3/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <RestKit/RestKit.h>

@protocol GoogleImageSearchDelegate

- (void)handleGoogleImageSearchResults:(NSArray *)results;

@end

@interface GoogleImageSearch : NSObject

@property (nonatomic, strong) id<GoogleImageSearchDelegate> delegate;

+ (void)searchWithKeywords:(NSArray *)keywords success:(void(^)(NSString *))success failure:(void(^)(NSString *))failure finally:(void(^)(NSString *))finally;

@end
