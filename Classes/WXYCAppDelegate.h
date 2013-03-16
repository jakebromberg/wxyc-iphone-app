//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

@class PlaylistController;

@interface WXYCAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) PlaylistController *livePlaylistCtrlr;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *rootController;

@end