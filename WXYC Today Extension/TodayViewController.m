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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
