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

@interface PlayerCell ()

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIImageView *leftCassetteReel;
@property (nonatomic, strong) IBOutlet UIImageView *rightCassetteReel;

@end

@implementation PlayerCell

+ (float)height
{
	return 74.0f;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    [self setUpObservation];
    
	return [super awakeAfterUsingCoder:aDecoder];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	@try {
        [self removeAllObservations];
	}
	@catch (NSException *exception) {
		
	}
	@finally {
        [self setUpObservation];
	}
	
	[self configureInterfaceForPlayingState:AudioStreamController.wxyc.isPlaying];
}

- (void)setUpObservation
{
    [self observeObject:[AudioStreamController wxyc] property:@keypath(AudioStreamController.wxyc, isPlaying) withBlock:^(__weak id self, __weak id object, id old, id new) {
        [self configureInterfaceForPlayingState:[AudioStreamController.wxyc isPlaying]];
    }];
}

- (void)configureInterfaceForPlayingState:(BOOL)isPlaying
{
	if (isPlaying)
	{
		[self.playButton setImage:[UIImage imageNamed:@"stop-button.png"] forState:UIControlStateNormal];
        [self.rightCassetteReel startSpin];
        [self.leftCassetteReel startSpin];
	} else {
		[self.playButton setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
        [self.rightCassetteReel stopSpin];
        [self.leftCassetteReel stopSpin];
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

@end
