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
#import "NSObject+KVOBlocks.h"

@interface LockscreenMediaController ()

@property (nonatomic, readonly) Playcut *firstPlaycut;

@end

@interface Playcut (LockscreenMediaController)

@property (nonatomic, readonly) NSDictionary *nowPlayingInfo;

@end

@implementation LockscreenMediaController

- (instancetype)init
{
	if (!(self = [super init]))
		return nil;
	
	id changeBlock = ^(NSDictionary *change)
	{
		[MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = self.firstPlaycut.nowPlayingInfo;
	};
	
	[[PlaylistController sharedObject] observeKeyPath:@keypath(PlaylistController *, playlist) changeBlock:changeBlock];
	[[AudioStreamController wxyc] observeKeyPath:@keypath(AudioStreamController *, isPlaying) changeBlock:changeBlock];
	
	return self;
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