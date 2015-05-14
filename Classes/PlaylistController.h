//
//  LivePlaylistController.h
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "NSObject+Singleton.h"

@class Playcut;

@interface PlaylistController : NSObject <XYCSingleton>

- (void)fetchPlaylistWithCompletionHandler:(id)completionHandler;
- (void)fetchPlaylist;

@end


@interface PlaylistController (Playlist)

@property (nonatomic, readonly) Playcut *firstPlaycut;
@property (nonatomic, strong, readonly) NSArray *playlistEntries;

@end