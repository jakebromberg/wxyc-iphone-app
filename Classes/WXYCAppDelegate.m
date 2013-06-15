//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "WXYCAppDelegate.h"
#import "PlaylistController.h"
#import "Playcut.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

// Use a class extension to expose access to MagicalRecord's private setter methods

@interface NSManagedObjectContext ()

+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;

@end

@implementation WXYCAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	// bootstrap the app
	[self configureAudioSession];
	[self configureRootView];
	[self configureCoreData];
	[self tidyUpCoreData];
	[self configureLivePlaylistController];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[self tidyUpCoreData];
}

#pragma mark - bootstrapping

- (void)configureAudioSession
{
	NSError *sessionError = nil;
	[[AVAudioSession sharedInstance] setDelegate:self];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
	
	NSAssert(!sessionError, @"");
	
	UInt32 doChangeDefaultRoute = 1;
	AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
}

- (void)configureRootView
{
	UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
	UIView *navView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationBar" owner:self.window.rootViewController options:nil] lastObject];
	[navController.navigationBar insertSubview:navView atIndex:navController.navigationBar.subviews.count];
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

- (void)tidyUpCoreData
{
	//Clean out unfavorited data
	for (Playcut *playcut in [Playcut findByAttribute:@"Favorite" withValue:@NO]) {
		[playcut deleteEntity];
	}
	
	[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (void)configureLivePlaylistController
{
	[self.livePlaylistCtrlr fetchPlaylist];
	
	[NSTimer scheduledTimerWithTimeInterval:30 target:self.livePlaylistCtrlr selector:@selector(fetchPlaylist) userInfo:nil repeats:YES];
}

- (PlaylistController *)livePlaylistCtrlr
{
	return _livePlaylistCtrlr ?: (_livePlaylistCtrlr = [[PlaylistController alloc] init]);
}

@end
