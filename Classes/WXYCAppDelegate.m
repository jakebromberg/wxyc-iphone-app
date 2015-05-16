//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "WXYCAppDelegate.h"
#import "XYCDataStack.h"
#import "LockscreenMediaController.h"
#import "PlaylistController.h"
#import "NSObject+KVOBlocks.h"

@implementation WXYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[self class] instantiateSingletons];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
//	[RKObjectManager.sharedManager observeKeyPath:@keypath(RKObjectManager.sharedManager, operationQueue.operationCount) changeBlock:^(NSDictionary *change)
//	{
//		BOOL isBusy = 0 != RKObjectManager.sharedManager.operationQueue.operationCount;
//		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isBusy];
//	}];

	return YES;
}

+ (void)instantiateSingletons
{
	[XYCDataStack loadSingleton];
	[PlaylistController loadSingleton];
	[LockscreenMediaController loadSingleton];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	[[PlaylistController sharedObject] fetchPlaylistWithCompletionHandler:completionHandler];
}

@end
