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
#import "UIView+Additions.h"

@class CassetteReelViewController;

@interface ListenViewController() {
//	AudioStreamController* streamController;
	CassetteReelViewController *upperController;
	CassetteReelViewController *lowerController;
}

@property (nonatomic, strong) AudioStreamController* streamController;

@end


@implementation ListenViewController

- (void)livePlaylistControllerStateChanged:(NSNotification *)aNotification {
	PlaylistController *livePlaylistCtrl = [aNotification object];
	
	if ([livePlaylistCtrl state] != LP_DONE) 
		return;

	for(id playlistEntry in livePlaylistCtrl.playlist) {
		if ([playlistEntry isKindOfClass:[Playcut class]]) {
			self.nowPlayingLabel.text = [NSString stringWithFormat: @"%@ — %@",
									[playlistEntry valueForKey:@"artist"], 
									[playlistEntry valueForKey:@"song"]];

			return;
		}
	}
	
	self.nowPlayingLabel.text = @"unavailable";
}

- (IBAction)pushPlay:(id)sender {
	if ([self.streamController isPlaying])
		return;

	[[AVAudioSession sharedInstance]
	 setCategory:AVAudioSessionCategoryPlayback
	 error: nil];
	
	[self.streamController start];
	[self setViewToPlayingState:YES];
}

- (IBAction)pushStop:(id)sender {
	[self.streamController stop];
	[self setViewToPlayingState:NO];
}

//TODO: All of the views in this code block should have controllers that respond to changing states themselves
-(void)setViewToPlayingState:(BOOL)isPlaying {
	[upperController animate:isPlaying];
	[lowerController animate:isPlaying];

	self.GreenLED.hidden = !isPlaying;
	self.RedLED.hidden = !isPlaying;
}

- (void)playbackStateChanged:(NSNotification *)aNotification {
	[self setViewToPlayingState:[self.streamController isPlaying]];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	NSURL *const url =
	#if TARGET_IPHONE_SIMULATOR
		[NSURL URLWithString:@"http://localhost/Masks.mp3"];
	#else
		[NSURL URLWithString:@"http://152.46.7.128:8000/wxyc.mp3"];
	#endif

	self.streamController = [[AudioStreamController alloc] initWithURL:url];
		
	//initialize the cassete reel view controllers
	lowerController = [[CassetteReelViewController alloc] initWithImageView:self.lowerCassetteReel];
	upperController = [[CassetteReelViewController alloc] initWithImageView:self.upperCassetteReel];

	//rotate or the label will look less than convincing
	self.nowPlayingLabel.transform = CGAffineTransformMakeRotation(-M_PI / 2);
	
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

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end