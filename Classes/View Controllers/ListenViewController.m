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

- (void) hideTabBar {
	WXYCAppDelegate* delegate = (WXYCAppDelegate*)[[UIApplication sharedApplication] delegate];
	UITabBarController *tabbarcontroller = delegate.rootController;
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
		
    }
	
    [UIView commitAnimations];	
}

- (void) showTabBar:(UITabBarController *) tabbarcontroller {
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        NSLog(@"%@", view);
		
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
			
        } 
        else 
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
		
		
    }
	
    [UIView commitAnimations]; 
}


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

	[self.GreenLED setHidden:isPlaying];
	[self.RedLED setHidden:isPlaying];
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

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end