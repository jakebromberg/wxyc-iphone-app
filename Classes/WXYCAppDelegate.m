//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "WXYCAppDelegate.h"
#import "PlaylistMapping.h"
#import "XYCDataStack.h"
#import "LockscreenMediaController.h"

@implementation WXYCAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[XYCDataStack loadSingleton];
	[PlaylistMapping loadSingleton];
	[LockscreenMediaController loadSingleton];
}

@end
