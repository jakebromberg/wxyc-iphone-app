
//
//  PlayerCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/10/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "PlayerCell.h"
#import "AudioStreamController.h"
#import "CassetteReelViewController.h"
#import "NSString+Additions.h"

@interface PlayerCell ()

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet CassetteReelViewController *leftCassetteReel;
@property (nonatomic, strong) IBOutlet CassetteReelViewController *rightCassetteReel;

@end

@implementation PlayerCell

+ (float)height
{
	return 74.0f;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	@try {
		[[AudioStreamController wxyc] removeObserver:self forKeyPath:@"isPlaying"];
	}
	@catch (NSException *exception) {
		
	}
	@finally {
		[[AudioStreamController wxyc] addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:NULL];
	}
	
	[self configureInterfaceForPlayingState:AudioStreamController.wxyc.isPlaying];
}

- (void)configureInterfaceForPlayingState:(BOOL)isPlaying
{
	if (isPlaying)
	{
		[self.playButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
		[self.leftCassetteReel startAnimation];
		[self.rightCassetteReel startAnimation];
	} else {
		[self.playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
		[self.leftCassetteReel stopAnimation];
		[self.rightCassetteReel stopAnimating];
	}
}

- (IBAction)pushPlay:(id)sender
{
	[self playPushButtonSFX];

	if ([AudioStreamController.wxyc isPlaying])
	{
		[AudioStreamController.wxyc stop];
	} else {
		[AudioStreamController.wxyc start];
	}
}

- (void)playPushButtonSFX
{
	SystemSoundID soundID;
	NSURL *url = [NSURL fileURLWithPath:[NSBundle.mainBundle.resourcePath append:@"/cassette button push.aif"]];
	
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
	AudioServicesPlaySystemSound(soundID);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"isPlaying"])
	{
		[self configureInterfaceForPlayingState:[AudioStreamController.wxyc isPlaying]];
	}
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
	[[AudioStreamController wxyc] addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:NULL];

	return [super awakeAfterUsingCoder:aDecoder];
}

@end
