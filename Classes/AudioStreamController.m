
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
#import <AVFoundation/AVFoundation.h>

@interface AudioStreamController()

@property (nonatomic, strong) AVPlayer *player;

@end


@implementation AudioStreamController

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
	NSError* error = nil;
	[[AVAudioSession sharedInstance] setActive:YES error:&error];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

	[self.player play];
}

- (void)stop
{
	[self.player pause];
}

- (BOOL)isPlaying
{
	return self.player.rate > 0;
}

- (AVPlayer *)player
{
	if (!_player)
		_player = [[AVPlayer alloc] initWithURL:self.URL];
	
	return _player;
}

#pragma mark

- (id)initWithURL:(NSURL*)URL
{
	self = [super init];
	
	if (self)
		_URL = URL;
	
	return self;
}

+ (NSSet *)keyPathsForValuesAffectingIsPlaying
{
	return [NSSet setWithObject:@"player.rate"];
}

@end
