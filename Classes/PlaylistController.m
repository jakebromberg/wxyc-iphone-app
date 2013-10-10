//
//  LivePlaylistController.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "PlaylistController.h"
#import "Playcut.h"
#import "AudioStreamController.h"
#import "NSArray+Additions.h"

NSString* const LPStatusChangedNotification = @"LPStatusChangedNotification";

@interface PlaylistController()

@property (nonatomic, strong, readwrite) NSMutableArray *playlist;
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
			@"referenceID" : [[self.playlist firstObject] valueForKeyPath:@"chronOrderID"] ?: @""
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
		 
		 NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_playlist.count, mappingResult.array.count)];

		 [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"playlist"];

		 NSArray *sortedArray = [mappingResult.array sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"chronOrderID" ascending:NO]]];
		 [self.playlist addObjectsFromArray:sortedArray];
		 
		 [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"playlist"];
		 
		 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	 }];
}
	 
#pragma mark constructors

+ (BOOL)automaticallyNotifiesObserversOfPlaylist
{
	return NO;
}

- (instancetype)init
{
	self = [super init];
	
	if (self)
	{
		_playlistMapping = [[PlaylistMapping alloc] init];
		_playlist = [NSMutableArray array];
		
		[self fetchPlaylist];
		[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(fetchPlaylist) userInfo:nil repeats:YES];
	}
	
	return self;
}

@end
