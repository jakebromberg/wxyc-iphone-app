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

typedef void(^OperationUnit)(id *accumulator, NSError **error);


@interface GoogleImageSearch ()

+ (NSURLRequest *)requestForKeywords:(NSArray *)keywords;

@end


@implementation GoogleImageSearch

+ (void)searchWithKeywords:(NSArray *)keywords completionHandler:(OperationHandler)operationHandler
{
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NULL);
	dispatch_block_t block = fetchData(keywords, operationHandler);
	
	dispatch_async(queue, block);
}

dispatch_block_t (^fetchData)(NSArray *, OperationHandler) = ^(NSArray *keywords, OperationHandler operationHandler)
{
	return ^{
		id operationBlocks = @[
			^(id *accumulator, NSError **error) {
			  *accumulator = [GoogleImageSearch requestForKeywords:keywords];
			},
			
			^(id *accumulator, NSError **error) {
			  *accumulator = [NSURLConnection sendSynchronousRequest:*accumulator returningResponse:nil error:error];
			},

			^(id *accumulator, NSError **error) {
			  *accumulator = [NSJSONSerialization JSONObjectWithData:*accumulator options:NSJSONReadingAllowFragments error:error];
			},

			^(id *accumulator, NSError **error) {
				*accumulator = (*accumulator)[@"responseData"];
				if (!*accumulator || ([NSNull null] == *accumulator))
					*error = [NSError errorWithDomain:@"" code:-1 userInfo:nil];
			},

			^(id *accumulator, NSError **error) {
				*accumulator = (*accumulator)[@"results"];
				if ([*accumulator count] == 0)
					*error = [NSError errorWithDomain:@"" code:@"" userInfo:nil];
			},

			^(id *accumulator, NSError **error) {
				*accumulator = (*accumulator)[0];
				if (!*accumulator || ([NSNull null] == *accumulator))
					*error = [NSError errorWithDomain:@"" code:@"" userInfo:nil];
			},
			
			^(id *accumulator, NSError **error) {
				*accumulator = (*accumulator)[@"url"];
				if (!*accumulator || ([NSNull null] == *accumulator))
					*error = [NSError errorWithDomain:@"" code:@"" userInfo:nil];
			},
			 
			^(id *accumulator, NSError **error) {
				*accumulator = [*accumulator stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				if (!*accumulator)
					*error = [NSError errorWithDomain:@"" code:@"" userInfo:nil];
			},
			

			^(id *accumulator, NSError **error) {
				operationHandler([NSURL URLWithString:*accumulator], *error);
			}
		];

		__block id accumulator;
		__block NSError *error;

		for(OperationUnit block in operationBlocks)
		{
			block(&accumulator, &error);
			
			if (error)
			{
				operationHandler(nil, error);
				break;
			}
		}
	};
};

+ (NSURLRequest *)requestForKeywords:(NSArray *)keywords
{
	NSString *query = [[keywords join:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString *urlString = [NSString stringWithFormat:IMAGE_SEARCH_URL,LARGE_IMG_SIZE, API_KEY, query];
	NSURL *URL = [NSURL URLWithString:urlString];
	
	return [NSURLRequest requestWithURL:URL];
}

@end
