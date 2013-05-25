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
	UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
	UIView *navView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationBar" owner:self.window.rootViewController options:nil] lastObject];
	[navController.navigationBar insertSubview:navView atIndex:navController.navigationBar.subviews.count];
	
	[self configureCoreData];
	[self tidyUpCoreData];
	[self.livePlaylistCtrlr fetchPlaylist];
	
	[NSTimer scheduledTimerWithTimeInterval:30 target:self.livePlaylistCtrlr selector:@selector(fetchPlaylist) userInfo:nil repeats:YES];
}

- (void)configureCoreData
{
	NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Playlist2" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"WXYC78.sqlite"];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    [managedObjectStore createManagedObjectContexts];
	
	// Configure MagicalRecord to use RestKit's Core Data stack
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
	
	RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://wxyc.info/"]];
    objectManager.managedObjectStore = managedObjectStore;
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

- (PlaylistController *)livePlaylistCtrlr
{
	if (!_livePlaylistCtrlr)
		_livePlaylistCtrlr = [[PlaylistController alloc] init];
	
	return _livePlaylistCtrlr;
}


@end
