//
//  CassetteReelView.m
//  WXYCapp
//
//  Created by Jake Bromberg on 9/22/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "CassetteReelView.h"
#import "AudioStreamController.h"
#import "UIView+Spin.h"

@implementation CassetteReelView

- (void)awakeFromNib
{
	NSKeyValueObservingOptions options = (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial);
	[[AudioStreamController wxyc] addObserver:self forKeyPath:@"isPlaying" options:options context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"isPlaying"])
	{
		if ([AudioStreamController wxyc].isPlaying)
			[self startSpin];
		else
			[self stopSpin];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)dealloc
{
	[[AudioStreamController wxyc] removeObserver:self forKeyPath:@"isPlaying"];
}

@end
