//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "LivePlaylistTableViewController.h"
#import "PlaylistController.h"
#import "PlayerCell.h"
#import "NSString+Additions.h"

#define NUMBER_OF_HEADER_CELLS 1

@implementation LivePlaylistTableViewController

#pragma Remote Control stuff

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[PlaylistController sharedObject] playlist].count + NUMBER_OF_HEADER_CELLS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
		return [tableView dequeueReusableCellWithIdentifier:@"PlayerCell" forIndexPath:indexPath];
	
	if (indexPath.row - NUMBER_OF_HEADER_CELLS >= [[PlaylistController sharedObject] playlist].count)
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
	
	return cell;
}

- (NSManagedObject *)playlistEntryForIndexPath:(NSIndexPath *)indexPath
{
	return ([[PlaylistController sharedObject] playlist])[indexPath.row - NUMBER_OF_HEADER_CELLS];
}

- (NSString *)classNameForPlaylistEntryAtIndexPath:(NSIndexPath*)indexPath
{
	return [[self playlistEntryForIndexPath:indexPath].class.description append:@"Cell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
		return [PlayerCell height];
	
	if (indexPath.row - NUMBER_OF_HEADER_CELLS >= [[PlaylistController sharedObject] playlist].count)
		return 0;
	
	return [NSClassFromString([self classNameForPlaylistEntryAtIndexPath:indexPath]) height];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[[PlaylistController sharedObject] addObserver:self forKeyPath:@"playlist" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"playlist"])
	{
		NSUInteger numNewEntries = [change[NSKeyValueChangeNewKey] count];

		if (numNewEntries == 0)
			return;
		
		NSMutableArray *newIndexPaths = [NSMutableArray arrayWithCapacity:numNewEntries];
		
		for (int i = 0; i < numNewEntries; i++) {
			[newIndexPaths addObject:[NSIndexPath indexPathForItem:i + NUMBER_OF_HEADER_CELLS inSection:0]];
		}
		
		[self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationFade];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end