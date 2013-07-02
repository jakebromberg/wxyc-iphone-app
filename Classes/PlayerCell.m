
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

#define PLAYER_STATE_KVO @"playerState"

@interface PlayerCell ()

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet CassetteReelViewController *leftCassetteReel;
@property (nonatomic, strong) IBOutlet CassetteReelViewController *rightCassetteReel;

@end

@implementation PlayerCell

#pragma mark - appearance

+ (float)height
{
	return 74.0f;
}

#pragma mark - life cycle

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
	[[AudioStreamController wxyc] addObserver:self forKeyPath:PLAYER_STATE_KVO options:NSKeyValueObservingOptionNew context:NULL];
	
	return [super awakeAfterUsingCoder:aDecoder];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	@try {
		[[AudioStreamController wxyc] removeObserver:self forKeyPath:PLAYER_STATE_KVO];
	}
	@catch (NSException *exception) {
		
	}
	@finally {
		[[AudioStreamController wxyc] addObserver:self forKeyPath:PLAYER_STATE_KVO options:NSKeyValueObservingOptionNew context:NULL];
	}
	
	[self configureInterface];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:PLAYER_STATE_KVO])
	{
		[self configureInterface];
	}
}

#pragma mark - view controller logic

- (void)configureInterface
{
	switch (AudioStreamController.wxyc.playerState) {
		case AudioStreamControllerStateUnknown:
		case AudioStreamControllerStateBuffering:
			[self.playButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
			break;
		case AudioStreamControllerStatePlaying:
			[self.playButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
			[self.leftCassetteReel startAnimation];
			[self.rightCassetteReel startAnimation];
		default:
			[self.playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
			[self.leftCassetteReel stopAnimation];
			[self.rightCassetteReel stopAnimating];

			break;
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
	
	[self configureInterface];
}

@end
