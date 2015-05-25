//
//  TodayViewController.m
//  WXYC Today Extension
//
//  Created by Jake Bromberg on 6/20/14.
//  Copyright (c) 2014 WXYC. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "PlaylistController.h"
#import "Playcut.h"

static const NCUpdateResult XYCBackgroundFetchMappings[] =
{
	[UIBackgroundFetchResultFailed] = NCUpdateResultFailed,
	[UIBackgroundFetchResultNewData] = NCUpdateResultNewData,
	[UIBackgroundFetchResultNoData] = NCUpdateResultNoData,
};

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, weak) IBOutlet UILabel *label;

@end


@implementation TodayViewController

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
	[[PlaylistController sharedObject] fetchPlaylistWithCompletionHandler:^(UIBackgroundFetchResult result)
	{
		Playcut *playcut = [[PlaylistController sharedObject] firstPlaycut];
		self.label.text = playcut.Song;
		completionHandler(XYCBackgroundFetchMappings[result]);
	}];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
	return defaultMarginInsets;
}

@end
