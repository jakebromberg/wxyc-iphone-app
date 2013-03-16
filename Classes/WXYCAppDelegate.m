//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "WXYCAppDelegate.h"
#import "PlaylistController.h"
#import "WXYCDataStack.h"

@implementation WXYCAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	_livePlaylistCtrlr = [[PlaylistController alloc] init];
	[_livePlaylistCtrlr fetchPlaylist];

	return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[self.window addSubview:_rootController.view];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

	[NSTimer scheduledTimerWithTimeInterval:30 target:self.livePlaylistCtrlr selector:@selector(fetchPlaylist) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	//Clean out old data from previous launch
	[[WXYCDataStack sharedInstance] purgeObsoleteEntries];
}

@end
