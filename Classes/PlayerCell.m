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

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIView *cassetteContainer;
@property (nonatomic, strong) UIImageView *leftCassetteReel;
@property (nonatomic, strong) UIImageView *cassetteBackground;
@property (nonatomic, strong) UIImageView *cassetteCenter;
@property (nonatomic, strong) UIImageView *rightCassetteReel;
@property (nonatomic, strong) UIImageView *leftCassetteArch;
@property (nonatomic, strong) UIImageView *rightCassetteArch;

@end


@implementation PlayerCell

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
        
        _cassetteContainer = [[UIView alloc] init];
        
//        _leftCassetteArch = [UIImage imageNamed:@"]
//
    }
    
    return self;
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
