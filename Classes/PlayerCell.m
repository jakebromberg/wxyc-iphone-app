//
//  PlayerCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/10/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "PlayerCell.h"
#import "AudioStreamController.h"
#import "NSString+Additions.h"
#import "UIView+Spin.h"

@interface PlayerCell ()

@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, strong) IBOutlet UIView *leftCassetteReel;
@property (nonatomic, strong) IBOutlet UIView *rightCassetteReel;

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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"isPlaying"])
	{
		[self configureInterfaceForPlayingState:[AudioStreamController.wxyc isPlaying]];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
	[[AudioStreamController wxyc] addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:NULL];

	return [super awakeAfterUsingCoder:aDecoder];
}

@end
