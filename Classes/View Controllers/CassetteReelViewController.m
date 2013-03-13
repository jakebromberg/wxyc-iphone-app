//
//  CassetteReelViewController.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "CassetteReelViewController.h"
#import "AudioStreamController.h"

@implementation CassetteReelViewController

- (void)setImageView:(UIImageView *)imageView
{
	[[AudioStreamController wxyc] addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:NULL];
	
	[super setImageView:imageView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([AudioStreamController wxyc].isPlaying)
		[self.imageView startAnimating];
	else
		[self.imageView stopAnimating];
}

@end
