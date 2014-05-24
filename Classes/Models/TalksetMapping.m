//
//  TalksetMapping.m
//  WXYCapp
//
//  Created by Jake Bromberg on 5/24/14.
//  Copyright (c) 2014 WXYC. All rights reserved.
//

#import "TalksetMapping.h"
#import "Talkset.h"

@implementation TalksetMapping

+ (NSString *)entityName
{
	return NSStringFromClass([Talkset class]);
}

+ (NSDictionary *)attributeMappings
{
	return @{
		@"id" : @"id",
		@"chronOrderID" : @keypath(Talkset *, chronOrderID),
		@"hour" : @keypath(Talkset *, hour)
	};
}

+ (NSArray *)identificationAttributes
{
	return @[@"id"];
}

+ (NSString *)keyPath
{
	return @"talksets";
}

@end
