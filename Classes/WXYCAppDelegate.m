//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "WXYCAppDelegate.h"
#import "XYCDataStack.h"
#import "PlaylistMapping.h"
#import "LockscreenMediaController.h"
#import "PlaylistController.h"

@implementation WXYCAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[[self class] instantiateSingletons];
}

+ (void)instantiateSingletons
{
	[XYCDataStack loadSingleton];
	[PlaylistController loadSingleton];
	[PlaylistMapping loadSingleton];
	[LockscreenMediaController loadSingleton];
}

@end
