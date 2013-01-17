//
//  PlaylistMapping.m
//  WXYCapp
//
//  Created by Jake Bromberg on 4/15/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "PlaylistMapping.h"
#import "Playcut.h"
#import "Talkset.h"
#import "Breakpoint.h"

@interface PlaylistMapping() {
	RKManagedObjectStore* objectStore;
	NSArray *playlistClasses;
}

@end

@implementation PlaylistMapping

NSString* baseURL = @"http://localhost/";

- (void)initializeObjectManager
{
	_objectManager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:baseURL]];
	_objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"WXYC2.sqlite"];
//	objectManager.objectStore = objectStore;
}

-(void)initializePlaycutMapping {
	RKManagedObjectMapping* playcutMapping = [RKManagedObjectMapping mappingForClass:[Playcut class] inManagedObjectStore:_objectManager.objectStore];
	
	[playcutMapping mapKeyPath:@"id" toAttribute:@"playlistEntryID"];
	[playcutMapping mapKeyPath:@"chronOrderID" toAttribute:@"chronOrderID"];
	[playcutMapping mapKeyPath:@"hour" toAttribute:@"hour"];
	[playcutMapping mapKeyPath:@"artistName" toAttribute:@"artist"];
	[playcutMapping mapKeyPath:@"labelName" toAttribute:@"label"];
	[playcutMapping mapKeyPath:@"releaseTitle" toAttribute:@"album"];
	[playcutMapping mapKeyPath:@"request" toAttribute:@"request"];
	[playcutMapping mapKeyPath:@"rotation" toAttribute:@"rotation"];
	[playcutMapping mapKeyPath:@"songTitle" toAttribute:@"song"];
	
	[_objectManager.mappingProvider setMapping:playcutMapping forKeyPath:@"playcuts"];
}

-(void)initializeBreakpointMapping
{
	RKManagedObjectMapping* breakpointMapping = [RKManagedObjectMapping mappingForClass:[Breakpoint class] inManagedObjectStore:_objectManager.objectStore];

	[breakpointMapping mapKeyPath:@"id" toAttribute:@"playlistEntryID"];
	[breakpointMapping mapKeyPath:@"chronOrderID" toAttribute:@"chronOrderID"];
	[breakpointMapping mapKeyPath:@"hour" toAttribute:@"hour"];
	
	[_objectManager.mappingProvider setMapping:breakpointMapping forKeyPath:@"breakpoints"];
}

-(void)initializeTalksetMapping
{
	RKManagedObjectMapping* talksetMapping = [RKManagedObjectMapping mappingForClass:[Talkset class] inManagedObjectStore:_objectManager.objectStore];

	[talksetMapping mapKeyPath:@"id" toAttribute:@"playlistEntryID"];
	[talksetMapping mapKeyPath:@"chronOrderID" toAttribute:@"chronOrderID"];
	[talksetMapping mapKeyPath:@"hour" toAttribute:@"hour"];
	
	[_objectManager.mappingProvider setMapping:talksetMapping forKeyPath:@"talksets"];
}

-(id)init
{
	if (self = [super init])
	{
		[self initializeObjectManager];
		[self initializePlaycutMapping];
		[self initializeBreakpointMapping];
		[self initializeTalksetMapping];
	}

	return self;
}

@end