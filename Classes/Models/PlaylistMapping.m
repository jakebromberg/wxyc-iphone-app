//
//  PlaylistMapping.m
//  WXYCapp
//
//  Created by Jake Bromberg on 4/15/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "PlaylistMapping.h"
//#import <CoreData/CoreData.h>
#import "Playcut.h"
#import "Talkset.h"
#import "Breakpoint.h"

@interface PlaylistMapping() {
	RKManagedObjectStore* objectStore;
	NSArray *playlistClasses;
}

@end

@implementation PlaylistMapping

@synthesize objectManager;
const NSString* baseURL = @"http://localhost/~jake/";

-(void)initializeObjectManager {
	objectManager = [RKObjectManager objectManagerWithBaseURL:[baseURL description]];
	objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"WXYC2.sqlite"];
}

-(void)initializePlaycutMapping {
	RKManagedObjectMapping* playcutMapping = [RKManagedObjectMapping mappingForClass:[Playcut class]];
	[objectManager.mappingProvider setMapping:playcutMapping forKeyPath:@"playcuts"];
	[playcutMapping mapKeyPath:@"id" toAttribute:@"playlistEntryID"];
	[playcutMapping mapKeyPath:@"chronOrderID" toAttribute:@"chronOrderID"];
	[playcutMapping mapKeyPath:@"hour" toAttribute:@"hour"];
	[playcutMapping mapKeyPath:@"artistName" toAttribute:@"artist"];
	[playcutMapping mapKeyPath:@"labelName" toAttribute:@"label"];
	[playcutMapping mapKeyPath:@"releaseTitle" toAttribute:@"album"];
	[playcutMapping mapKeyPath:@"request" toAttribute:@"request"];
	[playcutMapping mapKeyPath:@"rotation" toAttribute:@"rotation"];
	[playcutMapping mapKeyPath:@"songTitle" toAttribute:@"song"];
}

-(void)initializeBreakpointMapping {
	RKManagedObjectMapping* breakpointMapping = [RKManagedObjectMapping mappingForClass:[Breakpoint class]];
	[objectManager.mappingProvider setMapping:breakpointMapping forKeyPath:@"breakpoints"];
	[breakpointMapping mapKeyPath:@"id" toAttribute:@"playlistEntryID"];
	[breakpointMapping mapKeyPath:@"chronOrderID" toAttribute:@"chronOrderID"];
	[breakpointMapping mapKeyPath:@"hour" toAttribute:@"hour"];
}

-(void)initializeTalksetMapping {
	RKManagedObjectMapping* talksetMapping = [RKManagedObjectMapping mappingForClass:[Talkset class]];
	[objectManager.mappingProvider setMapping:talksetMapping forKeyPath:@"talksets"];
	[talksetMapping mapKeyPath:@"id" toAttribute:@"playlistEntryID"];
	[talksetMapping mapKeyPath:@"chronOrderID" toAttribute:@"chronOrderID"];
	[talksetMapping mapKeyPath:@"hour" toAttribute:@"hour"];
}

-(void)initializeMappings {
	[self initializeObjectManager];
	[self initializePlaycutMapping];
	[self initializeBreakpointMapping];
	[self initializeTalksetMapping];
}

-(id)init {
	self = [super init];
	[[self objectManager] retain];
	[self initializeMappings];

	return self;
}

@end