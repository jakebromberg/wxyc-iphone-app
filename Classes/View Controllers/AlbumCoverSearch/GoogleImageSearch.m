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

- (instancetype)init {
    return [self initWithKeywords:nil completionHandler:^(NSURL *imageURL, NSError *error) {
        
    }];
}

- (instancetype)initWithKeywords:(NSArray *)keywords completionHandler:(OperationHandler)completionHandler {
    completionHandler(nil, nil);
    return [super init];
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
