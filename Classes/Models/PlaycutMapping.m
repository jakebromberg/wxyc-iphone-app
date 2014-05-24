//
//  PlaycutMapping.m
//  WXYCapp
//
//  Created by Jake Bromberg on 5/24/14.
//  Copyright (c) 2014 WXYC. All rights reserved.
//

#import "PlaycutMapping.h"
#import "Playcut.h"

@implementation PlaycutMapping


+ (NSString *)entityName
{
	return NSStringFromClass([Playcut class]);
}

+ (NSDictionary *)attributeMappings
{
	return @{
		@"id" : @"id",
		@"chronOrderID" : @keypath(Playcut.new, chronOrderID),
		@"hour" : @keypath(Playcut.new, hour),
		@"artistName" : @keypath(Playcut.new, Artist),
		@"labelName" : @keypath(Playcut.new, Label),
		@"releaseTitle" : @keypath(Playcut.new, Album),
		@"request" : @keypath(Playcut.new, Request),
		@"rotation" : @keypath(Playcut.new, Rotation),
		@"songTitle" : @keypath(Playcut.new, Song)
	};
}

+ (NSArray *)identificationAttributes
{
	return @[@"id"];
}

+ (NSString *)keyPath
{
	return @"playcuts";
}

@end
