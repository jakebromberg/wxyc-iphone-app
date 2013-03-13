
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
	
	if (![AudioStreamController.wxyc isPlaying])
	{
		[AudioStreamController.wxyc start];
		self.playButton.imageView.image = [UIImage imageNamed:@"stop-button.png"];
		[self.leftCassetteReel stopAnimation];
	} else {
		[AudioStreamController.wxyc stop];
		self.playButton.imageView.image = [UIImage imageNamed:@"play-button.png"];
		[self.leftCassetteReel startAnimation];
	}
}

- (IBAction)pushPlay:(id)sender
{
	if (![AudioStreamController.wxyc isPlaying])
	{
		[AudioStreamController.wxyc start];
		self.playButton.imageView.image = [UIImage imageNamed:@"stop-button.png"];
	} else {
		[AudioStreamController.wxyc stop];
		self.playButton.imageView.image = [UIImage imageNamed:@"play-button.png"];
	}
}


@end
