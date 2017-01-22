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
#import "CALayer+ShadowLayer.h"

@interface PlayerCell ()

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIView *leftCassetteReel;
@property (nonatomic, weak) IBOutlet UIView *rightCassetteReel;

@property (nonatomic, strong) CALayer *shadowLayer;

@end


@implementation PlayerCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.clipsToBounds = NO;
	self.layer.masksToBounds = NO;
	
	self.containerView.layer.borderColor = [UIColor colorWithWhite:.70f alpha:1.f].CGColor;
	self.containerView.layer.borderWidth = 1.f;
	self.containerView.layer.cornerRadius = 5.f;
	self.containerView.layer.masksToBounds = YES;
}

- (instancetype)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
	[[AudioStreamController wxyc] addBlockObserver:self forKeyPath:@keypath(AudioStreamController.wxyc, isPlaying) changeBlock:^(NSDictionary *change) {
		[self configureInterfaceForPlayingState:[change[NSKeyValueChangeNewKey] boolValue]];
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
