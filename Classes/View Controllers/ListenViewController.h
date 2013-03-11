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

@property (nonatomic, weak) IBOutlet UIImageView *GreenLED;
@property (nonatomic, weak) IBOutlet UIImageView *RedLED;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UILabel *nowPlayingLabel;
@property (nonatomic, strong) IBOutlet CassetteReelViewController *lowerCassetteReelController;
@property (nonatomic, strong) IBOutlet CassetteReelViewController *upperCassetteReelController;

- (IBAction)pushPlay:(id)sender;
- (IBAction)pushStop:(id)sender;

@end