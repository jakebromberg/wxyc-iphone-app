
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

@interface AudioStreamController()

@property (nonatomic, strong) AVPlayer *player;

@end


@implementation AudioStreamController

- (id)initWithURL:(NSURL*)URL
{
	self = [super init];
	
	if (self)
	{
		_URL = URL;
		[self addObserver:self forKeyPath:@"playerState" options:NSKeyValueObservingOptionNew context:NULL];
	}
	
	return self;
}

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"player.status"];
}

#pragma mark - KVC/KVO Stuff

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"player.status"])
	{
		if (self.player.status == AVPlayerStatusFailed)
		{
			self.player = nil;
			[self player];
		}
	}
}

+ (NSSet *)keyPathsForValuesAffectingIsPlaying
{
	return [NSSet setWithObject:@"playerState"];
}

+ (NSSet *)keyPathsForValuesAffectingPlayerState
{
	return [NSSet setWithArray:@[
			@"player.currentItem.status",
			@"player.currentItem.playbackLikelyToKeepUp",
			@"player.currentItem.playbackBufferFull",
			@"player.currentItem.playbackBufferEmpty"
			]];
}

#pragma mark - WXYC Stuff

static AudioStreamController *wxyc;

+ (instancetype)wxyc
{
	if (!wxyc)
		wxyc = [[AudioStreamController alloc] initWithURL:[NSURL URLWithString:@"http://152.2.204.90:8000/wxyc.mp3"]];
	
	return wxyc;
}

#pragma mark - Public Methods

- (void)start
{
	[self.player play];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)stop
{
	[self.player pause];
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

#pragma mark - Getters

- (BOOL)isPlaying
{
	switch (self.playerState) {
		case AudioStreamControllerStateStopped:
		case AudioStreamControllerStateError:
		case AudioStreamControllerStateUnknown:
			return NO;
		default:
			return YES;
	}
}

- (AudioStreamControllerState)playerState
{
	if (self.player.currentItem.status == AVPlayerStatusFailed)
		return AudioStreamControllerStateError;
	
	if (self.player.currentItem.status == AVPlayerStatusUnknown)
		return AudioStreamControllerStateUnknown;
	
	if (self.player.currentItem.status == AVPlayerStatusReadyToPlay)
	{
		if (self.player.currentItem.playbackBufferEmpty && self.player.currentItem.playbackLikelyToKeepUp)
			return AudioStreamControllerStateBuffering;

		if (self.player.currentItem.playbackBufferFull || self.player.currentItem.playbackLikelyToKeepUp)
			return AudioStreamControllerStatePlaying;
	}
	
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
