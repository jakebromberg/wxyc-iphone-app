
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
//#import <AVFoundation/AVFoundation.h>

@interface AudioStreamController()

@property (nonatomic, strong) AVPlayer *player;

@end


@implementation AudioStreamController

static AudioStreamController *wxyc;

+ (instancetype)wxyc
{
	if (!wxyc)
		wxyc = [[AudioStreamController alloc] initWithURL:[NSURL URLWithString:@"http://audio-mp3.ibiblio.org:8000/wxyc.mp3"]];
	
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

- (BOOL)isPlaying
{
	return self.player.rate > 0;
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

#pragma mark

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"player.status"];
}

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

- (id)initWithURL:(NSURL*)URL
{
	self = [super init];
	
	if (self)
	{
		_URL = URL;
		[self addObserver:self forKeyPath:@"player.status" options:NSKeyValueObservingOptionNew context:NULL];
	}
	
	return self;
}

+ (NSSet *)keyPathsForValuesAffectingIsPlaying
{
	return [NSSet setWithObject:@"player.rate"];
}

@end
