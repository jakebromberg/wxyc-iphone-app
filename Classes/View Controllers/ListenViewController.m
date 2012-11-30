//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "ListenViewController.h"
#import "AudioStreamer.h"
#import "PlaylistController.h"
#import "CassetteReelViewController.h"
#import "Playcut.h"
#import "AudioStreamController.h"
#import "WXYCAppDelegate.h"

@class CassetteReelViewController;

@interface ListenViewController() {
//	AudioStreamController* streamController;
	CassetteReelViewController *upperController;
	CassetteReelViewController *lowerController;
}

@property (nonatomic, strong) AudioStreamController* streamController;

@end


@implementation ListenViewController

@synthesize GreenLED;
@synthesize RedLED;
@synthesize upperCassetteReel;
@synthesize lowerCassetteReel;
@synthesize playButton;
@synthesize stopButton;
@synthesize nowPlayingLabel;
@synthesize streamController;


- (void)livePlaylistControllerStateChanged:(NSNotification *)aNotification {
	PlaylistController *livePlaylistCtrl = [aNotification object];
	
	if ([livePlaylistCtrl state] != LP_DONE) 
		return;

	for(id playlistEntry in livePlaylistCtrl.playlist) {
		if ([playlistEntry isKindOfClass:[Playcut class]]) {
			nowPlayingLabel.text = [NSString stringWithFormat: @"%@ — %@", 
									[playlistEntry valueForKey:@"artist"], 
									[playlistEntry valueForKey:@"song"]];

			return;
		}
	}
	
	nowPlayingLabel.text = @"unavailable";
}

- (IBAction)pushPlay:(id)sender {
	if ([streamController isPlaying])
		return;

	[[AVAudioSession sharedInstance]
	 setCategory:AVAudioSessionCategoryPlayback
	 error: nil];
	
	[streamController start];
	[self setViewToPlayingState:YES];
}

- (IBAction)pushStop:(id)sender {
	[streamController stop];
	[self setViewToPlayingState:NO];
}

//TODO: All of the views in this code block should have controllers that respond to changing states themselves
-(void)setViewToPlayingState:(BOOL)isPlaying {
	[upperController animate:isPlaying];
	[lowerController animate:isPlaying];

	GreenLED.hidden = isPlaying;
	RedLED.hidden = isPlaying;
}

- (void)playbackStateChanged:(NSNotification *)aNotification {
	[self setViewToPlayingState:[streamController isPlaying]];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
#if TARGET_IPHONE_SIMULATOR
	NSURL *url = [NSURL URLWithString:@"http://localhost/Masks.mp3"];
#else
	NSURL *url = [NSURL URLWithString:@"http://152.46.7.128:8000/wxyc.mp3"];
#endif
	
	streamController = [[AudioStreamController alloc] initWithURL:url];
		
	//initialize the cassete reel view controllers
	lowerController = [[CassetteReelViewController alloc] initWithImageView:lowerCassetteReel];
	upperController = [[CassetteReelViewController alloc] initWithImageView:upperCassetteReel];

	//rotate or the label will look less than convincing
	nowPlayingLabel.transform = CGAffineTransformMakeRotation(-M_PI / 2);
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(livePlaylistControllerStateChanged:)
	 name:LPStatusChangedNotification
	 object:nil];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(playbackStateChanged:)
	 name:ASStatusChangedNotification
	 object:nil];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end