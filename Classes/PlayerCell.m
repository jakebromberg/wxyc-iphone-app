
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

@property (nonatomic, strong) AudioStreamController* streamController;
@property (nonatomic, strong) CassetteReelViewController *leftReelController;
@property (nonatomic, strong) CassetteReelViewController *rightReelController;

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIImageView *leftCassetteReel;
@property (nonatomic, weak) IBOutlet UIImageView *rightCassetteReel;

@end

@implementation PlayerCell

+ (float)height
{
	return 74.0f;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.leftReelController = [[CassetteReelViewController alloc] initWithImageView:self.leftCassetteReel];
	self.rightReelController = [[CassetteReelViewController alloc] initWithImageView:self.rightCassetteReel];
	
	NSURL *const url = [NSURL URLWithString:@"http://152.2.204.90:8000/wxyc.mp3"];
	
	self.streamController = [[AudioStreamController alloc] initWithURL:url];
}

- (IBAction)pushPlay:(id)sender
{
	if (![self.streamController isPlaying])
	{
		[self.streamController start];
		self.playButton.imageView.image = [UIImage imageNamed:@"stop-button.png"];
	} else {
		[self.streamController stop];
		self.playButton.imageView.image = [UIImage imageNamed:@"play-button.png"];
	}
}


@end
