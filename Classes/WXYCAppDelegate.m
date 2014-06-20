//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "WXYCAppDelegate.h"
#import "XYCDataStack.h"
#import "LockscreenMediaController.h"
#import "PlaylistController.h"

@implementation WXYCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[[self class] instantiateSingletons];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
	
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
