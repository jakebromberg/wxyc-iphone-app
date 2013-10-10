//
//  LivePlaylistController.h
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "PlaylistMapping.h"
#import "NSObject+Singleton.h"

@interface PlaylistController : NSObject <XYCSingleton>

- (void)fetchPlaylist;
- (PlaylistController*)init;

@end


@interface PlaylistController (Playlist)

@property (readonly, nonatomic, strong) NSArray *playlist;

@end