//
//  LockscreenMediaController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/9/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "LockscreenMediaController.h"
#import "PlaylistController.h"
#import "Playcut.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AudioStreamController.h"
#import "NSArray+Additions.h"

@interface LockscreenMediaController ()

@property (nonatomic, readonly) Playcut *firstPlaycut;

@end

@interface Playcut (LockscreenMediaController)

@property (nonatomic, readonly) NSDictionary *nowPlayingInfo;

@end

@implementation LockscreenMediaController

- (instancetype)init
{
	return COMMON_INIT([super init]);
}

- (void)commonInit
{
	[[PlaylistController sharedObject] addObserver:self forKeyPath:@"playlist" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
	[[AudioStreamController wxyc] addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"playlist"] || [keyPath isEqualToString:@"isPlaying"])
	{
		[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = self.firstPlaycut.nowPlayingInfo;
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (Playcut *)firstPlaycut
{
	return [[[PlaylistController sharedObject] playlist] objectPassingTest:^BOOL(id obj) {
		return [obj class] == [Playcut class];
	}];
}

@end


@implementation Playcut (LockscreenMediaController)

- (NSDictionary *)nowPlayingInfo
{
	return @{
		MPMediaItemPropertyAlbumTitle : self.Album ?: @"",
		MPMediaItemPropertyArtist : self.Artist ?: @"",
		MPMediaItemPropertyTitle : self.Song ?: @"",
		MPMediaItemPropertyArtwork : [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:self.PrimaryImage] ?: [UIImage imageNamed:@"album_cover_placeholder.PNG"]]
	};
}

@end