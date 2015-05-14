
//
//  AudioStreamController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/8/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "AudioStreamController.h"
#import <AVFoundation/AVFoundation.h>
#import "NSObject+KVOBlocks.h"

@interface AudioStreamController ()

@property (nonatomic, strong) AVPlayer *player;

@end


@implementation AudioStreamController

- (instancetype)initWithURL:(NSURL *)URL
{
	self = [super init];
	
	if (self)
	{
		_URL = [URL copy];
        
//        [self observeKeyPath:@keypath(self, player.status) changeBlock:^(NSDictionary *change) {
//            if (self.player.status == AVPlayerStatusFailed)
//            {
//                self.player = nil;
//                
//            }
//        }];
	}
	
	return self;
}

- (void)configureAudioSession
{
	NSError *error = nil;
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
	[[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
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
    if (!_player || _player.status == AVPlayerStatusFailed) {
        self.player = [[AVPlayer alloc] initWithURL:self.URL];
        self.player.usesExternalPlaybackWhileExternalScreenIsActive = YES;
    }
    
	return _player;
}

#pragma mark - Player methods

+ (NSSet *)keyPathsForValuesAffectingIsPlaying
{
    return [NSSet setWithObject:@keypath(AudioStreamController *, player.rate)];
}

@end


@implementation AudioStreamController (WXYC)


+ (instancetype)wxyc
{
	static AudioStreamController __strong *wxyc;
	
	if (!wxyc)
		wxyc = [[AudioStreamController alloc] initWithURL:[NSURL URLWithString:@"http://152.2.204.90:8000/wxyc.mp3"]];
	
	return wxyc;
}

@end
