//
//  VerticalLabel.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "NowPlayingLabel.h"
#import <math.h>
#import "PlaylistController.h"
#import "Playcut.h"

@implementation NowPlayingLabel

- (void)awakeFromNib
{
	self.transform = CGAffineTransformMakeRotation(-M_PI/2);
	
	[[NSNotificationCenter defaultCenter] addObserverForName:LPStatusChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *aNotification)
	{
		PlaylistController *livePlaylistCtrl = [aNotification object];
		
		if ([livePlaylistCtrl state] != LP_DONE)
			return;
		
		for (id playlistEntry in livePlaylistCtrl.playlist)
		{
			if ([playlistEntry isKindOfClass:[Playcut class]])
			{
				self.text = [NSString stringWithFormat: @"%@ — %@",
										 [playlistEntry valueForKey:@"artist"],
										 [playlistEntry valueForKey:@"song"]];
				
				return;
			}
		}
		
		self.text = @"unavailable";
	}];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
