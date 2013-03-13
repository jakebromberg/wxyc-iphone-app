//
//  AudioStreamController.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/8/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//
#include <AVFoundation/AVFoundation.h>

@interface AudioStreamController : NSObject

+ (instancetype)wxyc;

- (void)start;
- (void)stop;
- (id)initWithURL:(NSURL*)aURL;

@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly, strong) NSURL *URL;

@end