
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
#import "AudioStreamer.h"

@interface AudioStreamController() {
	AudioStreamer *streamer;
}

void interruptionListener(void *inClientData, UInt32 inInterruptionState);
- (void)destroyStreamer;
- (void)createStreamer;
- (void)playbackStateChanged:(NSNotification *)aNotification;

@end


@implementation AudioStreamController

@synthesize URL;


#pragma mark Public Methods

-(void)start{
	NSError* error = nil;
	[[AVAudioSession sharedInstance] setActive:YES error:&error];
	[[AVAudioSession sharedInstance]
	 setCategory:AVAudioSessionCategoryPlayback
	 error: nil];

	[self createStreamer];
	[streamer start];
}

-(void)stop{
	[streamer stop];
	[self destroyStreamer];
}

-(BOOL)isPlaying{
	return [streamer isPlaying];
}


#pragma mark Private Methods

- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
		 removeObserver:self
		 name:ASStatusChangedNotification
		 object:streamer];
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
	
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	
	//do this so we can still update the volume slider after we destroy the streamer
	NSError *activationError = nil;
	[session setActive:YES error: &activationError];
}

- (void)createStreamer
{
	if (streamer)
		return;
	
	[self destroyStreamer];
	
	streamer = [[AudioStreamer alloc] initWithURL:self.URL];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playbackStateChanged:)
	 name:ASStatusChangedNotification
	 object:streamer];
	
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer state] == AS_STOPPED) {
		if ([streamer errorCode] == AS_NO_ERROR) {
			NSError* error;
			[session setActive:NO error:&error];
		} else {
			[self stop];
			[self start];
		}
	}

	BOOL newNetworkActivityIndicatorVisibleState =
		([streamer isWaiting]) &&
		!([streamer isPlaying] || [streamer isIdle]);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = newNetworkActivityIndicatorVisibleState;
}

#pragma mark -
#pragma mark AVAudioSessionDelegate

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			if ([streamer isPlaying]) {
				[streamer stop];
			} else {
				[streamer start];
			}
			break;
		case UIEventSubtypeRemoteControlPlay:
			[streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
		case UIEventSubtypeRemoteControlStop:
			[streamer stop];
		default:
			break;
	}
//	if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
//		if ([streamer isPlaying]) {
//			[streamer stop];
//		} else {
//			[streamer start];
//		}
//	}
//	if (event.subtype == UIEventSubtypeRemoteControlPlay) {
//		[self pushPlay:nil];
//	}
//	if (event.subtype == UIEventSubtypeRemoteControlPause) {
//		[self pushStop:nil];
//	}
//	if (event.subtype == UIEventSubtypeRemoteControlStop) {
//		[self pushStop:nil];
//	}
//	if (event.subtype == UIEventSubtypeRemoteControlNextTrack) {
//		
//	}
//	if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
//		
//	}
}

- (void)beginInterruption {
	[streamer stop];
}

- (void)endInterruption { }

- (void) initAudioSession {
	session = [AVAudioSession sharedInstance];
	[session setDelegate:self];
	NSError *activationError = nil;
	[session setActive:YES error: &activationError];

	UInt32 otherAudioIsPlaying;
	UInt32 otherAudioIsPlaying_size = sizeof(otherAudioIsPlaying);
	
	AudioSessionGetProperty (kAudioSessionProperty_InterruptionType,
							 &otherAudioIsPlaying_size,
							 &otherAudioIsPlaying);
	
	if (otherAudioIsPlaying) {
		[[AVAudioSession sharedInstance]
		 setCategory: AVAudioSessionCategoryAmbient
		 error: nil];		
	} else {
		[[AVAudioSession sharedInstance]
		 setCategory:AVAudioSessionCategoryPlayback
		 error: nil];
	}
}


#pragma mark 

- (id)initWithURL:(NSURL*)aURL {
	self = [super init];
	[self setURL:aURL];
	
	return self;
}

- (void)dealloc {
	[self destroyStreamer];
    [super dealloc];
}

@end
