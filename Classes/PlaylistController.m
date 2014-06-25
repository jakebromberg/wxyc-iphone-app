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
#import "Playcut.h"

@interface PlaylistController()

@property (nonatomic, strong, readwrite) NSMutableArray *playlist;
@property (nonatomic, readonly) NSDictionary *parameters;
@property (nonatomic, readonly) NSString *path;

@end


@implementation PlaylistController

- (Playcut *)firstPlaycut
{
	return [self.playlist objectPassingTest:^BOOL(id obj) {
		return [obj isKindOfClass:[Playcut class]];
	}];
}

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

- (void)fetchPlaylistWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	[RKObjectManager.sharedManager getObjectsAtPath:self.path parameters:self.parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
	 {
		 if (mappingResult.array.count)
		 {
			 if (completionHandler) completionHandler(UIBackgroundFetchResultNewData);
		 } else {
			 if (completionHandler) completionHandler(UIBackgroundFetchResultNoData);
		 }
		 
		 [self appendResultsToPlaylist:[mappingResult.array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, id b) {
			 return ![self.playlist containsObject:evaluatedObject];
		 }]]];
		 
	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
		 if (completionHandler)
			 completionHandler(UIBackgroundFetchResultFailed);
	 }];
}

- (void)fetchPlaylist
{
	[self fetchPlaylistWithCompletionHandler:nil];
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
	if (!(self = [super init])) return nil;
	
	_playlist = [NSMutableArray array];

	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
	{
		[self fetchPlaylist];
		[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fetchPlaylist) userInfo:nil repeats:YES];
	}];

	return self;
}

@end
