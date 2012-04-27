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

@property (nonatomic, retain) AudioStreamController* streamController;

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

	[GreenLED setHidden:isPlaying];
	[RedLED setHidden:isPlaying];
}

- (void)playbackStateChanged:(NSNotification *)aNotification {
	[self setViewToPlayingState:[streamController isPlaying]];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
#if TARGET_IPHONE_SIMULATOR
	NSURL *url = [NSURL URLWithString:@"http://localhost/~jake/Masks.mp3"];
#else
	NSURL *url = [NSURL URLWithString:@"http://152.46.7.128:8000/wxyc.mp3"];
#endif
	
	streamController = [[[AudioStreamController alloc] initWithURL:url] retain];
		
	//initialize the cassete reel view controllers
	lowerController = [[[[CassetteReelViewController alloc] initWithImageView:lowerCassetteReel] retain] autorelease];
	upperController = [[[[CassetteReelViewController alloc] initWithImageView:upperCassetteReel] retain] autorelease];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:LPStatusChangedNotification
	 object:nil];
	
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:ASStatusChangedNotification
	 object:nil];
	
    [super dealloc];
}

@end