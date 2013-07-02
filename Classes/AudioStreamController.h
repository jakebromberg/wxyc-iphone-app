//
//  AudioStreamController.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/8/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//
#include <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, AudioStreamControllerState)
{
	AudioStreamControllerStateInitialized,
	AudioStreamControllerStateUnknown,
	AudioStreamControllerStatePlaying,
	AudioStreamControllerStateStopped,
	AudioStreamControllerStateBuffering,
	AudioStreamControllerStateError
};

@interface AudioStreamController : NSObject

- (void)start;
- (void)stop;
- (id)initWithURL:(NSURL*)aURL;

@property (nonatomic, readonly, getter = isPlaying) BOOL isPlaying;
@property (nonatomic, readonly, strong) NSURL *URL;
@property (nonatomic, readonly) AudioStreamControllerState playerState;

@end