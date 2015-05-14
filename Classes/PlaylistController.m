//
//  LivePlaylistController.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "PlaylistController.h"
#import "NSArray+Additions.h"
#import "Playcut.h"

@interface PlaylistController()

@property (nonatomic, strong, readwrite) NSArray *playlistEntries;
@property (nonatomic, readonly) NSDictionary *parameters;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSArray *queryItems;

@end


@implementation PlaylistController

- (Playcut *)firstPlaycut
{
	return [self.playlistEntries objectPassingTest:^BOOL(id obj) {
		return [obj isKindOfClass:[Playcut class]];
	}];
}

- (NSString *)path
{
	return @"/playlists/recentEntries";
}

- (NSArray *)queryItems
{
	NSString *referenceID = [self.playlistEntries.firstObject valueForKeyPath:@"chronOrderID"];
	
	if (referenceID)
	{
		return @[
			@"v=2",
			@"direction=next",
			[@"referenceID=" stringByAppendingString:referenceID]
		];
	}
	else
	{
		return @[
			@"v=2",
			@"n=100",
		];
	}
}

#pragma mark JSON Business

- (void)fetchPlaylistWithCompletionHandler:(id)completionHandler
{
	NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
	urlComponents.host = @"wxyc.info";
	urlComponents.path = self.path;
	urlComponents.percentEncodedQuery = [self.queryItems join:@"&"];
	urlComponents.scheme = @"http";
	
	NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:urlComponents.URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		
		if (error) {
			NSLog(@"%@", error.localizedDescription);
			return;
		}
		
		NSDictionary *fetchedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

		if (error) {
			NSLog(@"%@", error.localizedDescription);
			return;
		}
		
		for (id obj in fetchedResults[@"playcuts"]) {
			NSLog(@"%@", obj);
		}
	}];
	
	[task resume];
//	[RKObjectManager.sharedManager getObjectsAtPath:self.path parameters:self.parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
//	 {
//		 if (mappingResult.array.count == 0)
//		 {
//			 if (completionHandler)
//				 completionHandler(UIBackgroundFetchResultNoData);
//			 
//			 return;
//		 }
//
//		 NSIndexSet *indexes = [mappingResult.array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//			 return ![self.playlistEntries containsObject:obj];
//		 }];
//		 
//		 if (indexes.count == 0)
//		 {
//			 if (completionHandler)
//				 completionHandler(UIBackgroundFetchResultNoData);
//		 }
//		 else
//		 {
//			 NSArray *array = [mappingResult.array objectsAtIndexes:indexes];
//			 
//			 array = [mappingResult.array sortedArrayUsingComparator:^NSComparisonResult(PlaylistEntry *e1, PlaylistEntry *e2) {
//				 return [e2.chronOrderID compare:e1.chronOrderID];
//			 }];
//			 
//			 [self addPlaylistEntries:array];
//			 
//			 if (completionHandler)
//				 completionHandler(UIBackgroundFetchResultNewData);
//		 }
//         
//         [self performSelector:@selector(fetchPlaylist) withObject:nil afterDelay:5];
//	 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//		 if (completionHandler)
//			 completionHandler(UIBackgroundFetchResultFailed);
//
//         [self performSelector:@selector(fetchPlaylist) withObject:nil afterDelay:30];
//     }];
}

- (void)fetchPlaylist
{
	[self fetchPlaylistWithCompletionHandler:nil];
}

- (void)addPlaylistEntries:(NSArray *)entries
{
	if (entries.count == 0)
		return;
	
	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_playlistEntries.count, entries.count)];
	
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"playlistEntries"];
	
	NSArray *sortedArray = [entries sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"chronOrderID" ascending:NO]]];
    self.playlistEntries = [self.playlistEntries arrayByAddingObjectsFromArray:sortedArray];
	
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:@"playlistEntries"];
}

#pragma mark constructors

+ (BOOL)automaticallyNotifiesObserversOfPlaylist
{
	return NO;
}

- (instancetype)init
{
	if (!(self = [super init])) return nil;
	
	_playlistEntries = [NSArray array];

//	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
//	{
		[self fetchPlaylist];
//	}];

	return self;
}

@end
