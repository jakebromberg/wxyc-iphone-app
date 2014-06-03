//
//  PlayerCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/10/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "PlayerCell.h"
#import "AudioStreamController.h"
#import "UIView+Spin.h"
#import "NSObject+KVOBlocks.h"

@interface PlayerCell ()

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIView *leftCassetteReel;
@property (nonatomic, strong) IBOutlet UIView *rightCassetteReel;

@end

@implementation PlayerCell

+ (float)height
{
	return 84.0f;
}

- (instancetype)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
	__block __typeof(self) __self = self;
	
	[[AudioStreamController wxyc] addBlockObserver:self forKeyPath:@keypath(AudioStreamController.wxyc, isPlaying) changeBlock:^(NSDictionary *change) {
		[__self configureInterfaceForPlayingState:[change[NSKeyValueChangeNewKey] boolValue]];
	}];
	
	return [super awakeAfterUsingCoder:aDecoder];
}

- (void)configureInterfaceForPlayingState:(BOOL)isPlaying
{
	if (isPlaying)
	{
		[self.playButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
		[self.leftCassetteReel startSpin];
		[self.rightCassetteReel startSpin];
	} else {
		[self.playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
		[self.leftCassetteReel stopSpin];
		[self.rightCassetteReel stopSpin];
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

- (void)setHidden:(BOOL)hidden
{
	[super setHidden:hidden];
	
	[self configureInterfaceForPlayingState:[[AudioStreamController wxyc] isPlaying]];
}

@end
