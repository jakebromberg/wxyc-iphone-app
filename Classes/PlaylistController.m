//
//  LivePlaylistController.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "PlaylistController.h"
#import "NSString+Additions.h"
#import "Playcut.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AudioStreamController.h"
#import "NSArray+Additions.h"

NSString* const LPStatusChangedNotification = @"LPStatusChangedNotification";

@interface PlaylistController()

@property (nonatomic, strong) PlaylistMapping* playlistMapping;
@property (nonatomic, readonly) NSDictionary *parameters;
@property (nonatomic, readonly) NSString *path;

@end

@implementation PlaylistController

- (NSString *)path
{
	return @"playlists/recentEntries";
}

- (NSDictionary *)parameters
{
	if (self.playlist.count)
	{
		return @{
			@"v" : @"2",
			@"direction" : @"next",
			@"referenceID" : [self.playlist[0] valueForKeyPath:@"chronOrderID"] ?: @""
		};
	}
	else
	{
		return @{
			@"v" : @"2",
			@"n" : @"100",
		};
	}
}

#pragma mark JSON Business

- (void)fetchPlaylist
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[RKObjectManager.sharedManager getObjectsAtPath:self.path parameters:self.parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
	 {
		 if (mappingResult.array.count == 0)
			 return;
		 
		 NSComparisonResult (^comparator)(id a, id b) = ^NSComparisonResult(id a, id b){
			 return [[b valueForKey:@"chronOrderID"] compare:[a valueForKey:@"chronOrderID"]];
		 };
		 
		 NSArray *newEntries = [[mappingResult array] sortedArrayUsingComparator:comparator];
		 _playlist = [[[_playlist arrayByAddingObjectsFromArray:newEntries] sortedArrayUsingComparator:comparator] copy];
		 
		 _state = LP_DONE;
		 
		 [[NSNotificationCenter defaultCenter] postNotificationName:LPStatusChangedNotification object:self userInfo:@{ @"newEntries": newEntries}];
		 
		 [self configureNowPlayingInfo];
		 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	 }];
}
	 
- (void)configureNowPlayingInfo
{
	NSUInteger index = [self.playlist indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [obj class] == [Playcut class];
	}];
	
	if (index == NSNotFound) {
		return;
	}
	
	Playcut *playcut = self.playlist[index];
	
	[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo =
		@{
			MPMediaItemPropertyAlbumTitle : [playcut valueForKey:@"album"] ?: @"",
			MPMediaItemPropertyArtist : [playcut valueForKey:@"artist"] ?: @"",
			MPMediaItemPropertyTitle : [playcut valueForKey:@"song"] ?: @"",
		};
}

#pragma mark constructors

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[self configureNowPlayingInfo];
}

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_playlistMapping = [[PlaylistMapping alloc] init];
		_playlist = [NSArray array];
		[[AudioStreamController wxyc] addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:NULL];
	}
	
	return self;
}

@end
