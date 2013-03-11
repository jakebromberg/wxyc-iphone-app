//
//  GoogleImageSearch.m
//  WXYCapp
//
//  Created by Jake on 11/3/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "GoogleImageSearch.h"
#import "SBJSON.h"
#import "NSArray+Additions.h"

@implementation GoogleImageSearch

//static NSString *IMAGE_SEARCH_URL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=large&key=%@&q=album+%@";
static NSString *IMAGE_SEARCH_URL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=%@&key=%@&q=album+%@";
static const NSString *MED_IMG_SIZE = @"medium";
static const NSString *LARGE_IMG_SIZE = @"large";
static const NSString *API_KEY = @"ABQIAAAA5dyU_ZOZxVJ-rCQOTnH3khTF4zxbv1moelZ6wxYzrId3_vCc7hSxiVhd0OeM4oTlndTkE3v2ankvuA";

+ (void)searchWithKeywords:(NSArray *)keywords success:(void(^)(NSString *))success failure:(void(^)(NSString *))failure finally:(void(^)(NSString *))finally
{
	__block void (^_success)(NSString *) = success;
	__block void (^_failure)(NSString *) = failure;
	__block void (^_finally)(NSString *) = finally;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,NULL), ^{
		NSString *query = [[keywords join:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:IMAGE_SEARCH_URL, MED_IMG_SIZE, API_KEY, query, nil]];
		

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
			
			return;
		}
		
		NSArray *innerResults = results[@"responseData"][@"results"];
		
		if (innerResults.count) {
			_success([innerResults[0][@"url"] stringByReplacingURLEncoding]);
		} else {
			_failure(error.description);
		}
		
		if (_finally)
			_finally(@"");
	});
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	responseData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// Store incoming data into a string
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	// Create a dictionary from the JSON string
	NSMutableArray *results = [jsonString JSONValue];
	
	[_delegate handleGoogleImageSearchResults:results];
	
	responseData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"%@", error);
}

#pragma mark -

- (void)searchWithString:(NSString*)search {
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:IMAGE_SEARCH_URL, API_KEY, search, nil]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSArray*)synchronizedSearchWithString:(NSString*)search
{
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:IMAGE_SEARCH_URL,
									   LARGE_IMG_SIZE, 
									   API_KEY, 
									   [search stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
									   nil]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	// Create a dictionary from the JSON string
	NSMutableArray *results = [jsonString JSONValue];
	
	return results;
}

#pragma mark -

- (id)initWithDelegate:(id<GoogleImageSearchDelegate>) del
{
	self.delegate = del;
	responseData = [NSMutableData data];
	
	return [self init];
}

@end
