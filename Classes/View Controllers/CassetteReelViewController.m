//
//  CassetteReelViewController.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "CassetteReelViewController.h"
#import "WXYCStreamController.h"
#import "IndefinitelySpinningAnimation.h"

@interface CassetteReelViewController ()

@property (nonatomic, strong) IndefinitelySpinningAnimation *animation;

@end

@implementation CassetteReelViewController

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
	self = [super awakeAfterUsingCoder:aDecoder];
	
	if (self)
	{
		[[WXYCStreamController wxyc] addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:NULL];
		
		[self startAnimation];
		
		if (![WXYCStreamController wxyc].isPlaying)
			[self stopAnimation];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([WXYCStreamController wxyc].isPlaying)
		[self startAnimation];
	else
		[self stopAnimation];
}

- (void)startAnimation
{
	if (![self.layer animationForKey:@"spinAnimation"])
		[self.layer addAnimation:[IndefinitelySpinningAnimation getAnimation] forKey:@"spinAnimation"];
	
	CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

- (void)stopAnimation
{
	if (![self.layer animationForKey:@"spinAnimation"])
		[self.layer addAnimation:[IndefinitelySpinningAnimation getAnimation] forKey:@"spinAnimation"];
	
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

@end
