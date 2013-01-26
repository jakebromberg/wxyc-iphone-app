//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WalkmanVolumeSlider.h"
#import "IndefinitelySpinningImageViewController.h"

@class AudioStreamer;
@class CassetteReelViewController;
@class NowPlayingLabel;

@interface ListenViewController : UIViewController

@property (nonatomic, readonly, strong) IBOutlet UIImageView *GreenLED;
@property (nonatomic, readonly, strong) IBOutlet UIImageView *RedLED;
@property (nonatomic, readonly, strong) IBOutlet UIButton *playButton;
@property (nonatomic, readonly, strong) IBOutlet UIButton *stopButton;
@property (nonatomic, readonly, strong) IBOutlet UILabel *nowPlayingLabel;
@property (nonatomic, readonly, strong) IBOutlet CassetteReelViewController *lowerCassetteReelController;
@property (nonatomic, readonly, strong) IBOutlet CassetteReelViewController *upperCassetteReelController;

- (IBAction)pushPlay:(id)sender;
- (IBAction)pushStop:(id)sender;

@end