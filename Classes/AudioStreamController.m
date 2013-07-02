
//
//  AudioStreamController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/8/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "AudioStreamController.h"
#include <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>

#define PLAYER_STATE_KVO @"playerState"

@interface AudioStreamController ()

@property (nonatomic, strong) AVPlayer *player;

@end


@implementation AudioStreamController

- (id)initWithURL:(NSURL*)URL
{
	self = [super init];
	
	if (self)
	{
		_URL = URL;
//		[self addObserver:self forKeyPath:@"player.status" options:NSKeyValueObservingOptionNew context:NULL];
		[self addObserver:self forKeyPath:@"player.currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew context:NULL];
	}
	
	return self;
}

//- (void)dealloc
//{
//	[self removeObserver:self forKeyPath:@"player.status"];
//}

#pragma mark - KVC/KVO Stuff

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"player.currentItem.loadedTimeRanges"])
	{
		
	}
	
	if ([keyPath isEqualToString:@"player.status"])
	{
		if (_player.status == AVPlayerStatusFailed)
		{
			_player = nil;
//			[self player];
		}
	}
}

+ (NSSet *)keyPathsForValuesAffectingIsPlaying
{
	return [NSSet setWithObject:PLAYER_STATE_KVO];
}

+ (NSSet *)keyPathsForValuesAffectingPlayerState
{
	return [NSSet setWithArray:@[
			@"player.currentItem.status",
			@"player.currentItem.playbackLikelyToKeepUp",
			@"player.currentItem.playbackBufferFull",
//			@"player.currentItem.playbackBufferEmpty"
			]];
}

#pragma mark - Public Methods

- (void)start
{
	[self willChangeValueForKey:PLAYER_STATE_KVO];
	
	if (!_player)
		[self player];
	
	[_player play];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self didChangeValueForKey:PLAYER_STATE_KVO];
}

- (void)stop
{
	[self willChangeValueForKey:PLAYER_STATE_KVO];
	[_player pause];
	_player = nil;
	[self didChangeValueForKey:PLAYER_STATE_KVO];
}

#pragma mark - Getters

- (BOOL)isPlaying
{
	switch (self.playerState)
	{
		case AudioStreamControllerStatePlaying:
			return YES;
		default:
			return NO;
	}
}

- (AudioStreamControllerState)playerState
{
	if (!_player)
		return AudioStreamControllerStateInitialized;
	
	if (_player.status == AVPlayerStatusFailed)
		return AudioStreamControllerStateError;
	
	if (_player.status == AVPlayerStatusUnknown)
		return AudioStreamControllerStateUnknown;
	
	if (!_player.currentItem.playbackLikelyToKeepUp && _player.rate == 0)
		return AudioStreamControllerStateStopped;
	
	if ((_player.rate == 0.0f) && (_player.currentItem.playbackLikelyToKeepUp))
		return AudioStreamControllerStateBuffering;
	
	if ((_player.rate > 0) && (_player.status == AVPlayerStatusReadyToPlay))
		return AudioStreamControllerStatePlaying;

	return AudioStreamControllerStateStopped;
}

- (AVPlayer *)player
{
	if (!_player)
	{
		_player = [[AVPlayer alloc] initWithURL:self.URL];
		_player.usesExternalPlaybackWhileExternalScreenIsActive = YES;
	}
	
	return _player;
}

@end
