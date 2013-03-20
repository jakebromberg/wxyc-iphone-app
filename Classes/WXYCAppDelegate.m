//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "WXYCAppDelegate.h"
#import "PlaylistController.h"
#import "WXYCDataStack.h"

@implementation WXYCAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[MagicalRecord setDefaultModelNamed:@"Playlist.mom"];
//	[MagicalRecord setDefaultModelNamed:@"Playlist1.0.momd"];
	[MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"WXYC78.sqlite"];
	
	[self customizeTabBarAppearance];
	
	_livePlaylistCtrlr = [[PlaylistController alloc] init];
	[_livePlaylistCtrlr fetchPlaylist];
	
	[NSTimer scheduledTimerWithTimeInterval:30 target:self.livePlaylistCtrlr selector:@selector(fetchPlaylist) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	//Clean out old data from previous launch
	[[WXYCDataStack sharedInstance] purgeObsoleteEntries];
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

@end
