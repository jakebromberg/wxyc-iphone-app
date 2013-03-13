//
//  LivePlaylistController.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <RestKit/RestKit.h>
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
	[RKObjectManager.sharedManager getObjectsAtPath:@"/playlists/recentEntries?v=2" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
	 {
		 _playlist = [[mappingResult array] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
			 return [[b valueForKey:@"chronOrderID"] compare:[a valueForKey:@"chronOrderID"]];
		 }];
		 
		 self.state = LP_DONE;
		 NSLog(@"It Worked: %@", [mappingResult array]);
		 // Or if you're only expecting a single object:
		 NSLog(@"It Worked: %@", [mappingResult firstObject]);
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 NSLog(@"It Failed: %@", error);
	 }];
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
