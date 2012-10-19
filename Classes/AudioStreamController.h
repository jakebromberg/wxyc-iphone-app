//
//  AudioStreamController.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/8/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//
#include <AVFoundation/AVFoundation.h>

@class AudioStreamer;

@interface AudioStreamController : NSObject <AVAudioSessionDelegate> {
	@public
	
	@private
	AVAudioSession *session;
}

-(void)start;
-(void)stop;
-(id)initWithURL:(NSURL*)aURL;
-(BOOL)isPlaying;

@property (nonatomic, strong) NSURL* URL;

@end