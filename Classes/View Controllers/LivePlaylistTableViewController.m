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
#import "PlaylistEntry.h"
#import "NSString+Additions.h"

@implementation LivePlaylistTableViewController

PlaylistController* livePlaylistCtrl;

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return livePlaylistCtrl.playlist.count + 2;
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
	if (indexPath.row >= livePlaylistCtrl.playlist.count)
		return 0;
	
	return [NSClassFromString([self classNameForCellAtIndexPath:indexPath]) height];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	WXYCAppDelegate *appDelegate = (WXYCAppDelegate *)[UIApplication sharedApplication].delegate;
	livePlaylistCtrl = [appDelegate livePlaylistCtrlr];

	[self.tableView reloadData];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:LPStatusChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
	{
		if (livePlaylistCtrl.state == LP_DONE)
		{
			id newEntries = note.userInfo[@"newEntries"];
			NSMutableArray *newIndexPaths = [NSMutableArray arrayWithCapacity:[newEntries count]];
			
			for (int i = 0; i < [newEntries count]; i++) {
				[newIndexPaths addObject:[NSIndexPath indexPathForItem:i+2 inSection:0]];
			}
			
			[self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationFade];
		}
	}];
}

@end