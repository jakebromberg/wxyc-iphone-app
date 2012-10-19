//
//  GoogleImageSearch.m
//  WXYCapp
//
//  Created by Jake on 11/3/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "GoogleImageSearch.h"
//#import "NSString+SBJSON.h"

@implementation GoogleImageSearch

@synthesize delegate;

//static NSString *IMAGE_SEARCH_URL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=large&key=%@&q=album+%@";
static NSString *IMAGE_SEARCH_URL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=%@&key=%@&q=album+%@";
static const NSString *MED_IMG_SIZE = @"medium";
static const NSString *LARGE_IMG_SIZE = @"large";
static const NSString *API_KEY = @"ABQIAAAA5dyU_ZOZxVJ-rCQOTnH3khTF4zxbv1moelZ6wxYzrId3_vCc7hSxiVhd0OeM4oTlndTkE3v2ankvuA";

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// Store incoming data into a string
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
	
	// Create a dictionary from the JSON string
	NSMutableArray *results = [jsonString JSONValue];
	
	//NSLog(@"results %@", results);
	
	[delegate handleGoogleImageSearchResults:results];
	
	[jsonString release];
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"%@", error);
}

#pragma mark -

- (void)searchWithString:(NSString*)search {
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:IMAGE_SEARCH_URL, API_KEY, search, nil]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];	
}

- (NSArray*)synchronizedSearchWithString:(NSString*)search {
	NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:IMAGE_SEARCH_URL,
									   LARGE_IMG_SIZE, 
									   API_KEY, 
									   [search stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], 
									   nil]];
	
	//NSLog(@"GIS URL: %@", URL);
	
	NSURLRequest *request = [NSURLRequest requestWithURL:URL];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	NSString *jsonString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
	
	// Create a dictionary from the JSON string
	NSMutableArray *results = [jsonString JSONValue];
	
	return results;
}

#pragma mark -

- (id)initWithDelegate:(id<GoogleImageSearchDelegate>) del {
	self.delegate = del;
	responseData = [[NSMutableData data] retain];
	
	return [self init];
}

- (void)dealloc {
	[responseData dealloc];
	[parseQueue dealloc];
	[super dealloc];
}

@end
