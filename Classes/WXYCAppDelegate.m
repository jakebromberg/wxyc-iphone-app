//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "WXYCAppDelegate.h"
#import "PlaylistController.h"
#import "WXYCDataStack.h"
#import "Playcut.h"

// Use a class extension to expose access to MagicalRecord's private setter methods

@interface NSManagedObjectContext ()

+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;

@end

@implementation WXYCAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[self configureCoreData];
	[self tidyUpCoreData];
	[self customizeTabBarAppearance];
	[self.livePlaylistCtrlr fetchPlaylist];
	
	[NSTimer scheduledTimerWithTimeInterval:30 target:self.livePlaylistCtrlr selector:@selector(fetchPlaylist) userInfo:nil repeats:YES];
}

- (void)configureCoreData
{
//	[MagicalRecord setDefaultModelNamed:@"Playlist.mom"];
////	[MagicalRecord setDefaultModelNamed:@"Playlist1.0.momd"];
//	[MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"WXYC78.sqlite"];
	
	NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Playlist" ofType:@"mom"]];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"WXYC78.sqlite"];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    [managedObjectStore createManagedObjectContexts];
	
	// Configure MagicalRecord to use RestKit's Core Data stack
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];	
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[self tidyUpCoreData];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[self tidyUpCoreData];
}

- (void)tidyUpCoreData
{
	//Clean out unfavorited data
	for (Playcut *playcut in [Playcut findByAttribute:@"Favorite" withValue:@NO]) {
		[playcut deleteEntity];
	}
	
	[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (void)customizeTabBarAppearance
{
	UITabBar *tabBar = [self.window.rootViewController valueForKeyPath:@"tabBar"];

	[tabBar.items[0] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
	[tabBar.items[0] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-playlist-selected.png"]
				  withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-playlist-unselected.png"]];
	
	[tabBar.items[1] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
	[tabBar.items[1] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-favorites-selected.png"]
				  withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-favorites-unselected.png"]];
	
	[tabBar.items[2] setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
	[tabBar.items[2] setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-item-info-selected.png"]
				  withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-item-info-unselected.png"]];
}

- (PlaylistController *)livePlaylistCtrlr
{
	if (!_livePlaylistCtrlr)
		_livePlaylistCtrlr = [[PlaylistController alloc] init];
	
	return _livePlaylistCtrlr;
}

@end
