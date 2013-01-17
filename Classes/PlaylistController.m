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

NSString* const LPStatusChangedNotification = @"LPStatusChangedNotification";

@interface PlaylistController() {
	PlaylistMapping* playlistMapping;
}

@end

@implementation PlaylistController

- (void)setState:(PlaylistControllerState)aStatus
{
	if (_state != aStatus)
	{
		_state = aStatus;
		[[NSNotificationCenter defaultCenter] postNotificationName:LPStatusChangedNotification object:self];
	}
}

#pragma mark JSON Business

- (void)fetchPlaylist
{
	[playlistMapping.objectManager loadObjectsAtResourcePath:@"/new%20schema.json" delegate:self];
}

- (void)updatePlaylist {
	[self fetchPlaylist];
}

#pragma mark RestKit business

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
	_playlist = [[objects sortedArrayUsingComparator:^(id a, id b) {
		return [[a valueForKey:@"chronOrderID"] compare:[b valueForKey:@"chronOrderID"]];
	}] copy];
	
	self.state = LP_DONE;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
	NSLog(@"Encountered an error: %@", error);
}


#pragma mark constructors

- (id)initWithBaseURL:(NSString*)url
{
	self = [super init];
	
	if (self)
		playlistMapping = [[PlaylistMapping alloc] init];

	return self;
}


@end
