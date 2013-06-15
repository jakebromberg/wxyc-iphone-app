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

@interface PlaylistMapping()

@property (readonly) RKResponseDescriptor *playcutMapping;
@property (readonly) RKResponseDescriptor *talksetMapping;
@property (readonly) RKResponseDescriptor *breakpointMapping;

@end

@implementation PlaylistMapping

static NSString* baseURL = @"http://wxyc.info/";

- (void)initializeObjectManager
{
	[RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
	_objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseURL]];
	
	[RKManagedObjectStore setDefaultStore:[[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:[NSManagedObjectContext defaultContext].persistentStoreCoordinator]];
	_objectManager.managedObjectStore = [RKManagedObjectStore defaultStore];
	[_objectManager.managedObjectStore createManagedObjectContexts];
}

- (RKResponseDescriptor *)playcutMapping
{
	RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"Playcut" inManagedObjectStore:_objectManager.managedObjectStore];
	mapping.identificationAttributes = @[@"id"] ;
	
	[mapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"id",
		 @"chronOrderID": @"chronOrderID",
		 @"hour": @"hour",
		 @"artistName": @"artist",
		 @"labelName": @"label",
		 @"releaseTitle": @"album",
		 @"request": @"request",
		 @"rotation": @"rotation",
		 @"songTitle": @"song"
	 }];
	
	return [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:@"playcuts" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

- (RKResponseDescriptor *)breakpointMapping
{
	RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"Breakpoint" inManagedObjectStore:_objectManager.managedObjectStore];

	[mapping addAttributeMappingsFromDictionary:@{
		@"id": @"id",
		@"chronOrderID": @"chronOrderID",
		@"hour": @"hour"
	 }];
	
	mapping.identificationAttributes = @[@"id"] ;
	
	return [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:@"breakpoints" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

- (RKResponseDescriptor *)talksetMapping
{
	RKEntityMapping* mapping = [RKEntityMapping mappingForEntityForName:@"Talkset" inManagedObjectStore:_objectManager.managedObjectStore];
	[mapping addAttributeMappingsFromDictionary:@{
		@"id": @"id",
		@"chronOrderID": @"chronOrderID",
		@"hour": @"hour"
	 }];
	
	mapping.identificationAttributes = @[@"id"] ;
	
	return [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:@"talksets" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

- (id)init
{
	if (self = [super init])
	{
		[self initializeObjectManager];

		[[RKObjectManager sharedManager] addResponseDescriptor:self.playcutMapping];
		[[RKObjectManager sharedManager] addResponseDescriptor:self.talksetMapping];
		[[RKObjectManager sharedManager] addResponseDescriptor:self.breakpointMapping];
	}

	return self;
}

@end