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

@implementation LockscreenMediaController

- (instancetype)init
{
	self = [super init];
	
	if (!self)
		return nil;
	
	[[PlaylistController sharedObject] addObserver:self forKeyPath:@"playlist" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
	[[AudioStreamController wxyc] addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:NULL];
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"playlist"] || [keyPath isEqualToString:@"isPlaying"])
	{
		[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [self nowPlayingInfoForPlaycut:[self firstPlaycut]];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (Playcut *)firstPlaycut
{
	NSArray *playlist = [[PlaylistController sharedObject] playlist];

	NSUInteger index = [playlist indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return [obj class] == [Playcut class];
	}];
	
	if (index == NSNotFound)
	{
		return nil;
	} else {
		return playlist[index];
	}
}

- (NSDictionary *)nowPlayingInfoForPlaycut:(Playcut *)playcut
{
	return @{
		MPMediaItemPropertyAlbumTitle : playcut.Album ?: @"",
		MPMediaItemPropertyArtist : playcut.Artist ?: @"",
		MPMediaItemPropertyTitle : playcut.Song ?: @"",
		MPMediaItemPropertyArtwork : [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:playcut.PrimaryImage] ?: [UIImage imageNamed:@"album_cover_placeholder.PNG"]]
	};
}

@end
