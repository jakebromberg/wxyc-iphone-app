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

#pragma mark - Core Data stack

- (NSManagedObjectContext *) managedObjectContext
{
	
    if (_managedObjectContext)
        return _managedObjectContext;
	
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator)
	{
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
		_managedObjectContext.persistentStoreCoordinator = coordinator;
    }
	
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
	
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
        return _persistentStoreCoordinator;
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WXYC.sqlite"]];
	
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle the error.
    }    
	
    return _persistentStoreCoordinator;
}


#pragma mark - Application's documents directory

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

#pragma mark -

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSURL* url = [NSURL URLWithString:@"http://www.wxyc.info/"];
	_livePlaylistCtrlr = [[PlaylistController alloc] initWithBaseURL:url];
	[_livePlaylistCtrlr fetchPlaylist];

	return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[_window addSubview:_rootController.view];
	[_window makeKeyAndVisible];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

	WXYCDataStack *ds = [WXYCDataStack sharedInstance];
	[ds setStoreURL:[NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WXYC.sqlite"]]];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}	
	
	//Clean out old data from previous launch
    if (_managedObjectContext)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Favorite == %@) || (Favorite == %@)", nil, @NO];	
		
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playcut" inManagedObjectContext:_managedObjectContext];
		[request setEntity:entity];
		[request setPredicate:predicate];
		
		NSLog(@"LivePlaylistTableViewController");
		
		NSArray *fetchResults = nil;
		NSError *error = nil;
		if ((fetchResults = [_managedObjectContext executeFetchRequest:request error:&error])) {
			for(Playcut *cut in fetchResults) {
				[_managedObjectContext deleteObject:cut];
			}
		} else {
			NSLog(@"Error %@", error);
		}		
		
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
			// Handle the error.
        } 
    }

	NSTimer *updatePlaylist;
	updatePlaylist = [NSTimer scheduledTimerWithTimeInterval:30 target:self.livePlaylistCtrlr selector:@selector(fetchPlaylist) userInfo:nil repeats:YES];
}

@end
