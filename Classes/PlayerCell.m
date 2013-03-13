
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

@interface PlayerCell ()

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet CassetteReelViewController *leftCassetteReel;
@property (nonatomic, weak) IBOutlet CassetteReelViewController *rightCassetteReel;

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
	
	[self configureInterfaceForPlayingState:[AudioStreamController.wxyc isPlaying]];
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
	if ([AudioStreamController.wxyc isPlaying])
	{
		[AudioStreamController.wxyc stop];
	} else {
		[AudioStreamController.wxyc start];
	}
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

	[self configureInterfaceForPlayingState:[AudioStreamController wxyc].isPlaying];
	
	return [super awakeAfterUsingCoder:aDecoder];
}

@end
