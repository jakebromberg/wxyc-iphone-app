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
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "Breakpoint.h"
#import "Talkset.h"

@interface PlaylistController()
@interface PlaylistController ()

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
	urlComponents.scheme = @"http";
	urlComponents.host = @"wxyc.info";
	urlComponents.path = self.path;
	urlComponents.percentEncodedQuery = [self.queryItems join:@"&"];
	
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
		
		NSManagedObjectContext *context = [NSManagedObjectContext MR_rootSavingContext];

		for (NSDictionary *playcut in fetchedResults[@"breakpoints"]) {
			Breakpoint *e = [Breakpoint MR_createInContext:context];
			e.chronOrderID = playcut[@"chronOrderID"];
			e.hour = playcut[@"hour"];
		}

		for (NSDictionary *playcut in fetchedResults[@"talksets"]) {
			Talkset *t = [Talkset MR_createInContext:context];
			t.chronOrderID = playcut[@"chronOrderID"];
			t.hour = playcut[@"hour"];
		}
		
		for (NSDictionary *playcut in fetchedResults[@"playcuts"]) {
			Playcut *p = [Playcut MR_createInContext:context];
			p.Artist = playcut[@"artistName"];
			p.chronOrderID = playcut[@"chronOrderID"];
			p.hour = playcut[@"hour"];
			p.Label = playcut[@"labelName"];
			p.Request = @([playcut[@"request"] boolValue]);
			p.Rotation = @([playcut[@"rotation"] boolValue]);
			p.Song = playcut[@"songTitle"];
			p.Album = playcut[@"releaseTitle"];
		}

		[context save:&error];
		
		if (error) {
			NSLog(@"%@", error);
		}
	}];
	
	[task resume];
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


	return self;
}

@end
