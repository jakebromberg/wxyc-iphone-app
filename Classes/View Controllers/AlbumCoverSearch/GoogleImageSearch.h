//
//  GoogleImageSearch.h
//  WXYCapp
//
//  Created by Jake on 11/3/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoogleImageSearchDelegate

-(void) handleGoogleImageSearchResults:(NSArray *)results;

@end

@interface GoogleImageSearch : NSObject {
	id<GoogleImageSearchDelegate> delegate;
	NSMutableData *responseData;
@private
	NSOperationQueue *parseQueue;	
}

@property (nonatomic, retain) id<GoogleImageSearchDelegate> delegate;

- (id)initWithDelegate:(id<GoogleImageSearchDelegate>) del;
- (void)searchWithString:(NSString*)search;
- (NSArray*)synchronizedSearchWithString:(NSString*)search;

@end
