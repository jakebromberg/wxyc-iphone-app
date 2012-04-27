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

@property (nonatomic, readonly, retain) IBOutlet UIImageView *GreenLED;
@property (nonatomic, readonly, retain) IBOutlet UIImageView *RedLED;
@property (nonatomic, readonly, retain) IBOutlet IndefinitelySpinningImageViewController *upperCassetteReel;
@property (nonatomic, readonly, retain) IBOutlet IndefinitelySpinningImageViewController *lowerCassetteReel;
@property (nonatomic, readonly, retain) IBOutlet UIButton *playButton;
@property (nonatomic, readonly, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, readonly, retain) IBOutlet UILabel *nowPlayingLabel;

- (IBAction)pushPlay:(id)sender;
- (IBAction)pushStop:(id)sender;

@end