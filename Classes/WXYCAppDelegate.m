//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "WXYCAppDelegate.h"
#import "PlaylistController.h"
#import "WXYCDataStack.h"
#import "Playcut.h"

@implementation WXYCAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize livePlaylistCtrlr;

@synthesize fetchedResultsController, managedObjectContext, managedObjectModel, persistentStoreCoordinator;

#pragma mark -
#pragma mark Fetched results controller

- (void)handleTimer {
	[livePlaylistCtrlr updatePlaylist];
}

#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
		managedObjectContext.persistentStoreCoordinator = coordinator;
    }
	
    return managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    
	return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WXYC.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle the error.
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

#pragma mark -

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[window addSubview:rootController.view];
	[window makeKeyAndVisible];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

	WXYCDataStack *ds = [WXYCDataStack sharedInstance];
	[ds setStoreURL:[NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WXYC.sqlite"]]];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}	
	
	//Clean out old data from previous launch
    if (managedObjectContext != nil) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Favorite == %@) || (Favorite == %@)", nil, @NO];	
		
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playcut" inManagedObjectContext:managedObjectContext];
		[request setEntity:entity];
		[request setPredicate:predicate];
		
		NSLog(@"LivePlaylistTableViewController");
		
		NSArray *fetchResults = nil;
		NSError *error = nil;
		if ((fetchResults = [managedObjectContext executeFetchRequest:request error:&error])) {
			NSLog(@"fetchResults: %@", fetchResults);
			for(Playcut *cut in fetchResults) {
				[managedObjectContext deleteObject:cut];
			}
		} else {
			NSLog(@"Error %@", error);
		}		
		
		
		
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle the error.
        } 
    }

	

	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	
	NSError *setCategoryError = nil;
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
	if (setCategoryError) { /* handle the error condition */ }
	
	NSError *activationError = nil;
	[audioSession setActive:YES error:&activationError];
	if (activationError) {
		/* handle the error condition */ 
	}
	
	NSURL* url = [NSURL URLWithString:@"http://localhost/"];
	livePlaylistCtrlr = [[PlaylistController alloc] initWithBaseURL:url];
	[livePlaylistCtrlr fetchPlaylist];
	
//	NSTimer *updatePlaylist;
//	updatePlaylist = [NSTimer scheduledTimerWithTimeInterval: 30
//													  target: livePlaylistCtrlr
//													selector: @selector(updatePlaylist)
//													userInfo: nil
//													 repeats: YES];
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive"];
//}

@end
