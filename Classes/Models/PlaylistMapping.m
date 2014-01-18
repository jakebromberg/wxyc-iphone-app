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

static NSString *baseURL = @"http://wxyc.info/";

- (instancetype)init
{
	return COMMON_INIT([super init]);
}

- (void)commonInit
{
	[self initializeObjectManager];
	[self addMappingsToObjectManager];
}

- (void)initializeObjectManager
{
	[RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
	
	[RKManagedObjectStore setDefaultStore:[[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:[NSManagedObjectContext defaultContext].persistentStoreCoordinator]];

	_objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseURL]];
	_objectManager.managedObjectStore = [RKManagedObjectStore defaultStore];
	[_objectManager.managedObjectStore createManagedObjectContexts];
	
	[RKObjectManager setSharedManager:_objectManager];
}

#pragma mark Mappings

- (void)addMappingsToObjectManager
{
	[[RKObjectManager sharedManager] addResponseDescriptor:self.playcutMapping];
	[[RKObjectManager sharedManager] addResponseDescriptor:self.talksetMapping];
	[[RKObjectManager sharedManager] addResponseDescriptor:self.breakpointMapping];
}

- (RKResponseDescriptor *)playcutMapping
{
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Playcut class]) inManagedObjectStore:_objectManager.managedObjectStore];
	mapping.identificationAttributes = @[@"id"] ;
	
	[mapping addAttributeMappingsFromDictionary:@{
		 @"id" : @"id",
		 @"chronOrderID": @keypath(Playcut.new, chronOrderID),
		 @"hour": @keypath(Playcut.new, hour),
		 @"artistName": @keypath(Playcut.new, Artist),
		 @"labelName": @keypath(Playcut.new, Label),
		 @"releaseTitle": @keypath(Playcut.new, Album),
		 @"request": @keypath(Playcut.new, Request),
		 @"rotation": @keypath(Playcut.new, Rotation),
		 @"songTitle": @keypath(Playcut.new, Song)
	 }];
	
	return [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"playcuts" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

- (RKResponseDescriptor *)breakpointMapping
{
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Breakpoint" inManagedObjectStore:_objectManager.managedObjectStore];

	[mapping addAttributeMappingsFromDictionary:@{
		@"id": @"id",
		@"chronOrderID": @keypath(Playcut.new, chronOrderID),
		@"hour": @keypath(Playcut.new, hour)
	 }];
	
	mapping.identificationAttributes = @[@"id"];
	
	return [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"breakpoints" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

- (RKResponseDescriptor *)talksetMapping
{
	RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:@"Talkset" inManagedObjectStore:_objectManager.managedObjectStore];
	[mapping addAttributeMappingsFromDictionary:@{
		@"id": @"id",
		@"chronOrderID": @keypath(Playcut.new, chronOrderID),
		@"hour": @keypath(Playcut.new, hour)
	 }];
	
	mapping.identificationAttributes = @[@"id"];
	
	return [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"talksets" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

@end
