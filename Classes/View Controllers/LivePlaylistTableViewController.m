//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "LivePlaylistTableViewController.h"
#import "WXYCAppDelegate.h"
#import "LoadPreviousEntriesCell.h"
#import "PlaylistController.h"
#import "WXYCDataStack.h"
#import "PlaycutCell.h"
#import "PlayerCell.h"
#import "TalksetCell.h"
#import "NSString+Additions.h"

@interface LivePlaylistTableViewController ()

@property (nonatomic, strong) PlayerCell *playerCell;

@end

@implementation LivePlaylistTableViewController

static const int kNumEntriesToFetch = 20;

PlaylistController* livePlaylistCtrl;

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (livePlaylistCtrl.playlist.count == 0)
		return 2;
	
	if ([self maxEntriesToDisplay] >= livePlaylistCtrl.playlist.count)
		_maxEntriesToDisplay = livePlaylistCtrl.playlist.count;

	return [self maxEntriesToDisplay]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
		return [tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];

	if (indexPath.row == 1)
		return [tableView dequeueReusableCellWithIdentifier:@"PlayerCell" forIndexPath:indexPath];
	
	NSManagedObject *playlistEntry = livePlaylistCtrl.playlist[indexPath.row - 2];
	NSString *entryType = [playlistEntry.class.description append:@"Cell"];
	LivePlaylistTableViewCell *cell;
	
	@try {
		cell = [tableView dequeueReusableCellWithIdentifier:entryType forIndexPath:indexPath];
	}
	@catch (NSException *exception) {
		Class class = NSClassFromString(entryType);
		
		if (class) {
			cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:entryType];
		} else {
			cell = [[LivePlaylistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unknown"];
		}
	}
	
	cell.entity = playlistEntry;
	cell.delegate = self;
	
	return cell;
}

- (NSString *)classNameForCellAtIndexPath:(NSIndexPath*)indexPath
{
	NSManagedObject *playlistEntry = (livePlaylistCtrl.playlist)[indexPath.row - 2];
	return [playlistEntry.class.description append:@"Cell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 1)
		return [PlayerCell height];
	
	if (indexPath.row == 0)
		return 40;
	
	//boundary case
	if (indexPath.row > ([self maxEntriesToDisplay]))
		return 0;
	
	return [NSClassFromString([self classNameForCellAtIndexPath:indexPath]) height];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	_maxEntriesToDisplay = kNumEntriesToFetch;
	
	WXYCAppDelegate *appDelegate = (WXYCAppDelegate *)[UIApplication sharedApplication].delegate;
	livePlaylistCtrl = [appDelegate livePlaylistCtrlr];

	[self.tableView reloadData];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:LPStatusChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
	{
		if (livePlaylistCtrl.state == LP_DONE)
			[self.tableView reloadData];
	}];
}

@end