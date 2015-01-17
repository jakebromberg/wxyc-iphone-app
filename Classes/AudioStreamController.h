//
//  AudioStreamController.h
//  WXYCapp
//
//  Created by Jake Bromberg on 3/8/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

@interface AudioStreamController : NSObject

- (instancetype)initWithURL:(NSURL *)aURL NS_DESIGNATED_INITIALIZER;
- (void)start;
- (void)stop;

@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly, strong) NSURL *URL;

@end

@interface AudioStreamController (WXYC)

+ (instancetype)wxyc;

@end