//
//  LivePlaylistController.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "PlaylistController.h"
#import "NSArray+Additions.h"

@interface PlaylistController()

@property (nonatomic, strong, readwrite) NSMutableArray *playlist;
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
		 [self appendResultsToPlaylist:mappingResult.array];
		 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	 }];
}

- (void)appendResultsToPlaylist:(NSArray *)results
{
	if (results.count == 0)
		return;
	
	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_playlist.count, results.count)];
	
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"playlist"];
	
	NSArray *sortedArray = [results sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"chronOrderID" ascending:NO]]];
	[self.playlist addObjectsFromArray:sortedArray];
	
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"playlist"];
}

#pragma mark constructors

+ (BOOL)automaticallyNotifiesObserversOfPlaylist
{
	return NO;
}

- (instancetype)init
{
	return COMMON_INIT([super init]);
}

- (void)commonInit
{
	_playlist = [NSMutableArray array];
	
	[self fetchPlaylist];
	[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(fetchPlaylist) userInfo:nil repeats:YES];
}

@end
