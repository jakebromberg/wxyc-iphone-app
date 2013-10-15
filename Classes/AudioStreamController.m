
//
//  AudioStreamController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/8/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "AudioStreamController.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioStreamController()

@property (nonatomic, strong) AVPlayer *player;

@end


@implementation AudioStreamController

- (instancetype)initWithURL:(NSURL*)URL
{
	self = [super init];
	
	if (self)
	{
		_URL = URL;
        
        [self observeProperty:@keypath(self.player.status) withBlock:^(__weak AudioStreamController *self, id old, id new) {
             if (self.player.status == AVPlayerStatusFailed)
             {
                 self.player = nil;
                 [self player];
             }
         }];
	}
	
	return self;
}

- (void)configureAudioSession
{
	NSError *error = nil;
	[[AVAudioSession sharedInstance] setDelegate:self];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
	[[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
}


#pragma WXYC factory method

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
	[self configureAudioSession];
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

+ (NSSet *)keyPathsForValuesAffectingIsPlaying
{
	return [NSSet setWithObject:@keypath(AudioStreamController.new, player.rate)];
}

@end
