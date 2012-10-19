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
@class VerticalLabel;

@interface ListenViewController : UIViewController

@property (nonatomic, readonly, strong) IBOutlet UIImageView *GreenLED;
@property (nonatomic, readonly, strong) IBOutlet UIImageView *RedLED;
@property (nonatomic, readonly, strong) IBOutlet IndefinitelySpinningImageViewController *upperCassetteReel;
@property (nonatomic, readonly, strong) IBOutlet IndefinitelySpinningImageViewController *lowerCassetteReel;
@property (nonatomic, readonly, strong) IBOutlet UIButton *playButton;
@property (nonatomic, readonly, strong) IBOutlet UIButton *stopButton;
@property (nonatomic, readonly, strong) IBOutlet UILabel *nowPlayingLabel;

- (IBAction)pushPlay:(id)sender;
- (IBAction)pushStop:(id)sender;

@end