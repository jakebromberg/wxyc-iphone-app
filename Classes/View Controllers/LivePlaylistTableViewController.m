//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "LivePlaylistTableViewController.h"
#import "WXYCAppDelegate.h"
#import "PlaylistController.h"
#import "PlayerCell.h"
#import "NSString+Additions.h"
#import "AudioStreamController.h"

#define NUMBER_OF_HEADER_CELLS 1

@interface LivePlaylistTableViewController ()

@property (nonatomic, strong) PlaylistController *livePlaylistCtrl;

@end

@implementation LivePlaylistTableViewController

#pragma Remote Control stuff

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
	if ((receivedEvent.type != UIEventTypeRemoteControl) ||
		(receivedEvent.subtype != UIEventSubtypeRemoteControlTogglePlayPause))
		return;

	if ([AudioStreamController wxyc].isPlaying)
		[[AudioStreamController wxyc] stop];
	else
		[[AudioStreamController wxyc] start];
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.livePlaylistCtrl.playlist.count + NUMBER_OF_HEADER_CELLS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
		return [tableView dequeueReusableCellWithIdentifier:@"PlayerCell" forIndexPath:indexPath];
	
	if (indexPath.row - NUMBER_OF_HEADER_CELLS >= self.livePlaylistCtrl.playlist.count)
		return nil;
	
	NSString *entryType = [self classNameForPlaylistEntryAtIndexPath:indexPath];
	
	LivePlaylistTableViewCell *cell;
	
	@try {
		cell = [tableView dequeueReusableCellWithIdentifier:entryType forIndexPath:indexPath];
	}
	@catch (...)
	{
		Class class = NSClassFromString(entryType);
		
		if (class) {
			cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:entryType];
		} else {
			cell = [[LivePlaylistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unknown"];
		}
	}
	
	cell.entity = [self playlistEntryForIndexPath:indexPath];
	cell.delegate = self;
	
	return cell;
}

- (NSManagedObject *)playlistEntryForIndexPath:(NSIndexPath *)indexPath
{
	return (self.livePlaylistCtrl.playlist)[indexPath.row - NUMBER_OF_HEADER_CELLS];
}

- (NSString *)classNameForPlaylistEntryAtIndexPath:(NSIndexPath*)indexPath
{
	return [[self playlistEntryForIndexPath:indexPath].class.description append:@"Cell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
		return [PlayerCell height];
	
	//boundary case
	if (indexPath.row - NUMBER_OF_HEADER_CELLS >= self.livePlaylistCtrl.playlist.count)
		return 0;
	
	return [NSClassFromString([self classNameForPlaylistEntryAtIndexPath:indexPath]) height];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[[NSNotificationCenter defaultCenter] addObserverForName:LPStatusChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
	{
		if (self.livePlaylistCtrl.state == LP_DONE)
		{
			NSArray *newEntries = note.userInfo[@"newEntries"];
			
			if (newEntries.count == 0)
				return;
				
			NSMutableArray *newIndexPaths = [NSMutableArray arrayWithCapacity:[newEntries count]];
			
			for (int i = 0; i < [newEntries count]; i++) {
				[newIndexPaths addObject:[NSIndexPath indexPathForItem:i + NUMBER_OF_HEADER_CELLS inSection:0]];
			}
			
			[self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationFade];
		}
	}];
}

#pragma - Initializer stuff

- (PlaylistController *)livePlaylistCtrl
{
	if (!_livePlaylistCtrl)
	{
		WXYCAppDelegate *appDelegate = (WXYCAppDelegate *)[UIApplication sharedApplication].delegate;
		_livePlaylistCtrl = [appDelegate livePlaylistCtrlr];
	}

	return _livePlaylistCtrl;
}

@end