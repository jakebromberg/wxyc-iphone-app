//
//  LivePlaylistController.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PlaylistController.h"
#import "Playcut.h"
#import "Talkset.h"
#import "Breakpoint.h"
#import "PlaylistMapping.h"
//@class PlaylistMapping;

NSString* const LPStatusChangedNotification = @"LPStatusChangedNotification";
//RKObjectManager* objectManager;

@interface PlaylistController() {
	PlaylistMapping* playlistMapping;
}

@end

@implementation PlaylistController

@synthesize playlist;
@synthesize state;
//@synthesize numNewEntries;


- (void)setState:(PlaylistControllerState)aStatus {
	if (state != aStatus) {
		state = aStatus;
		[[NSNotificationCenter defaultCenter] postNotificationName:LPStatusChangedNotification object:self];
	}
}

#pragma mark JSON Business

- (void)fetchPlaylist {
	[playlistMapping.objectManager loadObjectsAtResourcePath:@"/new%20schema.json" delegate:self];
}

- (void)updatePlaylist {
	[self fetchPlaylist];
}

#pragma mark RestKit business

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
	playlist = [[objects sortedArrayUsingComparator:^(id a, id b) {
		return [[a valueForKey:@"chronOrderID"] compare:[b valueForKey:@"chronOrderID"]];
	}] copy];
	
	[self setState:LP_DONE];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
	NSLog(@"Encountered an error: %@", error);
}


#pragma mark constructors

-(PlaylistController*)initWithBaseURL:(NSString*)url {
//	self = [super init];
	playlistMapping = [[[PlaylistMapping alloc] init] retain];

	return self;
}

//-(void)initializeMappings {
//	RKManagedObjectStore* objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"WXYC.sqlite"];
//	objectManager.objectStore = objectStore;
//	
//	RKManagedObjectMapping* playcutMapping = [RKManagedObjectMapping mappingForClass:[Playcut class]];
//	[objectManager.mappingProvider setMapping:playcutMapping forKeyPath:@"playcuts"];
//	[playcutMapping mapKeyPath:@"id" toAttribute:@"playlistEntryID"];
//	[playcutMapping mapKeyPath:@"chronOrderID" toAttribute:@"chronOrderID"];
//	[playcutMapping mapKeyPath:@"hour" toAttribute:@"hour"];
//	[playcutMapping mapKeyPath:@"artistName" toAttribute:@"artist"];
//	[playcutMapping mapKeyPath:@"labelName" toAttribute:@"label"];
//	[playcutMapping mapKeyPath:@"releaseTitle" toAttribute:@"album"];
//	[playcutMapping mapKeyPath:@"request" toAttribute:@"request"];
//	[playcutMapping mapKeyPath:@"rotation" toAttribute:@"rotation"];
//	[playcutMapping mapKeyPath:@"songTitle" toAttribute:@"song"];
//	
//	
//	RKManagedObjectMapping* breakpointMapping = [RKManagedObjectMapping mappingForClass:[Breakpoint class]];
//	[objectManager.mappingProvider setMapping:breakpointMapping forKeyPath:@"breakpoints"];
//	[breakpointMapping mapKeyPath:@"id" toAttribute:@"playlistEntryID"];
//	[breakpointMapping mapKeyPath:@"chronOrderID" toAttribute:@"chronOrderID"];
//	[breakpointMapping mapKeyPath:@"hour" toAttribute:@"hour"];
//	
//	RKManagedObjectMapping* talksetMapping = [RKManagedObjectMapping mappingForClass:[Talkset class]];
//	[objectManager.mappingProvider setMapping:talksetMapping forKeyPath:@"talksets"];
//	[talksetMapping mapKeyPath:@"id" toAttribute:@"playlistEntryID"];
//	[talksetMapping mapKeyPath:@"chronOrderID" toAttribute:@"chronOrderID"];
//	[talksetMapping mapKeyPath:@"hour" toAttribute:@"hour"];
//}

- (void)dealloc {
    [super dealloc];
	[playlistMapping dealloc];
}

@end
