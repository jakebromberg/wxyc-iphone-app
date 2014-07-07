//
//  GoogleImageSearch.m
//  WXYCapp
//
//  Created by Jake on 11/3/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "GoogleImageSearch.h"
#import "NSArray+Additions.h"

@interface GoogleImageSearch ()

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) OperationHandler completionHandler;

@end


@implementation GoogleImageSearch

- (instancetype)initWithKeywords:(NSArray *)keywords completionHandler:(OperationHandler)completionHandler
{
	if (!(self = [super init])) return nil;
	
	self.completionHandler = completionHandler;
	
	__weak __typeof(self) wSelf = self;
	
	NSString *query = [self.class queryForKeywords:keywords];
	NSURL *URL = [self.class URLForQuery:query];
	
	self.task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
	{
		__typeof(self) sSelf = wSelf;
		
		if (error)
		{
			sSelf.completionHandler(nil, error);
			return;
		}
		
		id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		
		if (error)
		{
			sSelf.completionHandler(nil, error);
			return;
		}
		
		NSString *URLString = [[obj valueForKeyPath:@"responseData.results.url"] firstObject];
		NSURL *URL = [NSURL URLWithString:URLString];
		
		sSelf.completionHandler(URL, nil);
	}];
	
	[self.task resume];
	
	return self;
}

- (void)cancel
{
	[self.task cancel];
}

+ (NSURL *)URLForQuery:(NSString *)query
{
	static NSString *kImageSearchURL = @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=%@&key=%@&q=%@";
	static const NSString *kLargeImage = @"large";
	static const NSString *kAPIKey = @"ABQIAAAA5dyU_ZOZxVJ-rCQOTnH3khTF4zxbv1moelZ6wxYzrId3_vCc7hSxiVhd0OeM4oTlndTkE3v2ankvuA";

	NSString *URLString = [NSString stringWithFormat:kImageSearchURL, kLargeImage, kAPIKey, query];
	
	return [NSURL URLWithString:URLString];
}

+ (NSString *)queryForKeywords:(NSArray *)keywords
{
	return [[keywords join:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)dealloc
{
	[self.task cancel];
}

@end
