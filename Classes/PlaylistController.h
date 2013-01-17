//
//  LivePlaylistController.h
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "PlaylistMapping.h"

typedef enum {
	LP_INITIALIZED = 0,
	LP_WAITING_FOR_DATA,
	LP_FETCHING,
	LP_PARSING,
	LP_DONE
} PlaylistControllerState;

@interface PlaylistController : NSObject <RKObjectLoaderDelegate>
{
	NSNotificationCenter *notificationCenter;
}

extern NSString * const LPStatusChangedNotification;

- (void)fetchPlaylist;
- (void)updatePlaylist;

-(PlaylistController*)initWithBaseURL:(NSURL*)url;

@property (readonly) PlaylistControllerState state;
@property (readonly, nonatomic, strong) NSArray *playlist;

@end