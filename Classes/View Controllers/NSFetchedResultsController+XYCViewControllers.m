//
//  NSFetchedResultsController+XYCViewControllers.m
//  WXYCapp
//
//  Created by Jake Bromberg on 1/31/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "NSFetchedResultsController+XYCViewControllers.h"

@implementation NSFetchedResultsController (XYCViewControllers)

+ (instancetype)livePlaylistFetchedResultsController
{
	return [[NSFetchedResultsController alloc] initWithFetchRequest:[self livePlaylistFetchRequest] managedObjectContext:[NSManagedObjectContext defaultContext] sectionNameKeyPath:nil cacheName:nil];
}

+ (instancetype)favoritesFetchedResultsController
{
	return [[NSFetchedResultsController alloc] initWithFetchRequest:[self favoritesFetchRequest] managedObjectContext:[NSManagedObjectContext defaultContext] sectionNameKeyPath:nil cacheName:nil];
}

+ (NSFetchRequest *)livePlaylistFetchRequest
{
	static NSFetchRequest *fetchRequest;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"chronOrderID" ascending:NO]];
	});
	
	return fetchRequest;
}

+ (NSFetchRequest *)favoritesFetchRequest
{
	static NSFetchRequest *fetchRequest;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Playcut"];
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"Favorite", @YES];
		fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"chronOrderID" ascending:NO]];
	});
	
	return fetchRequest;
}

@end
