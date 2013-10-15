//
//  GoogleImageSearch.m
//  WXYCapp
//
//  Created by Jake on 11/3/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "GoogleImageSearch.h"
#import "NSArray+Additions.h"
#import "NSString+Additions.h"

static NSString *IMAGE_SEARCH_URL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=%@&key=%@&q=%@";
static const NSString *LARGE_IMG_SIZE = @"large";
static const NSString *API_KEY = @"ABQIAAAA5dyU_ZOZxVJ-rCQOTnH3khTF4zxbv1moelZ6wxYzrId3_vCc7hSxiVhd0OeM4oTlndTkE3v2ankvuA";

typedef id(^OperationUnit)(id accumulator, NSError **error);

@implementation GoogleImageSearch

+ (void)searchWithKeywords:(NSArray *)keywords handler:(OperationHandler)operationHandler
{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NULL);
	dispatch_block_t block = fetchData(keywords, operationHandler);
	
	dispatch_async(queue, block);
}

+ (NSArray *)operationBlocks
{
    return @[
		^(NSArray *keywords, NSError **error) {
			NSString *query = [[keywords join:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSString *urlString = [IMAGE_SEARCH_URL formattedWith:@[LARGE_IMG_SIZE, API_KEY, query]];
			NSURL *URL = [NSURL URLWithString:urlString];
			
			return [NSURLRequest requestWithURL:URL];
		},

		^(NSURLRequest *accumulator, NSError **error) {
			return [NSURLConnection sendSynchronousRequest:accumulator returningResponse:nil error:error];
		},

		^(NSData *accumulator, NSError **error) {
			return [NSJSONSerialization JSONObjectWithData:accumulator options:NSJSONReadingAllowFragments error:error];
		},

		^(NSDictionary *accumulator, NSError **error) {
			return [accumulator valueForKeyPath:@"responseData.results.url"];
		},

		^(id accumulator, NSError **error) {
			return [accumulator firstObject];
		},

		^(id accumulator, NSError **error) {
			return [accumulator stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		},
	];
}

dispatch_block_t (^fetchData)(NSArray *, OperationHandler) = ^(NSArray *keywords, OperationHandler operationHandler)
{
	return ^{

		__block __strong id accumulator = keywords;
		__block NSError *error;

		for(OperationUnit block in [GoogleImageSearch operationBlocks])
		{
			accumulator = block(accumulator, &error);
			
			if (error || !accumulator || ([NSNull null] == accumulator))
			{
				operationHandler(nil, error ?: [NSError errorWithDomain:@"" code:1 userInfo:nil]);
				return;
			}
		}
        
        operationHandler([NSURL URLWithString:accumulator], error);
	};
};

@end
