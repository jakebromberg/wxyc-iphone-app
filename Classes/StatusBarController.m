//
//  StatusBarController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/1/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "StatusBarController.h"
#import "WXYCStreamController.h"
#import "MTStatusBarOverlay.h"

@implementation StatusBarController

- (id)init
{
	self = [super init];
	
	if (!self)
		return nil;

	[[WXYCStreamController wxyc] addObserver:self forKeyPath:@"playerState" options:NSKeyValueObservingOptionNew context:NULL];
	
	return self;
}

- (void)dealloc
{
	[[WXYCStreamController wxyc] removeObserver:self forKeyPath:@"playerState"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	switch ([WXYCStreamController wxyc].playerState) {
		case AudioStreamControllerStateUnknown:
			[NSTimer timerWithTimeInterval:5 target:self selector:@selector(dismissOverlay) userInfo:nil repeats:NO];
		case AudioStreamControllerStateBuffering:
		{
			MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
			overlay.animation = MTStatusBarOverlayAnimationFallDown;
			overlay.detailViewMode = MTDetailViewModeHistory;
			[overlay postMessage:@"Buffering…"];
			break;
		}
		case AudioStreamControllerStateError:
			[[MTStatusBarOverlay sharedInstance] postErrorMessage:@"Whoops. Try that again." duration:3];
			break;
		default:
			[[MTStatusBarOverlay sharedInstance] hide];
			break;
	}
}

- (void)dismissOverlay
{
	[[MTStatusBarOverlay sharedInstance] hide];
}

@end
