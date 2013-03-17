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

@implementation GoogleImageSearch

static NSString *IMAGE_SEARCH_URL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=%@&key=%@&q=%@";
static const NSString *LARGE_IMG_SIZE = @"large";
static const NSString *API_KEY = @"ABQIAAAA5dyU_ZOZxVJ-rCQOTnH3khTF4zxbv1moelZ6wxYzrId3_vCc7hSxiVhd0OeM4oTlndTkE3v2ankvuA";

+ (void)searchWithKeywords:(NSArray *)keywords success:(void(^)(NSString *))success failure:(void(^)(NSString *))failure finally:(void(^)(NSString *))finally
{
	__block void (^_success)(NSString *) = success;
	__block void (^_failure)(NSString *) = failure;
	__block void (^_finally)(NSString *) = finally;
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,NULL);
	dispatch_async(queue, ^{
		NSString *query = [[keywords join:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *urlString = [IMAGE_SEARCH_URL formattedWith:@[LARGE_IMG_SIZE, API_KEY, query]];
		NSURL *URL = [NSURL URLWithString:urlString];
		

		NSURLRequest *request = [NSURLRequest requestWithURL:URL];
		NSURLResponse *response = nil;
		NSError *error = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

		if (error)
		{
			if (_failure)
				_failure(error.description);
			
			return;
		}
		
		// Create a dictionary from the JSON string
		NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
		
		if (error)
		{
			if (_failure)
				_failure(error.description);
			
			if (_finally)
				finally(@"");
			
			return;
		}
		
		NSArray *innerResults = results[@"responseData"][@"results"];
		
		if (innerResults.count) {
			_success([innerResults[0][@"url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
		} else {
			if (_failure)
				_failure(error.description);
		}
		
		if (_finally)
			_finally(@"");
	});
}

@end
