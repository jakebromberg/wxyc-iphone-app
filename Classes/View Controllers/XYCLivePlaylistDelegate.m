//
//  XYCSimpleTableViewDelegate.m
//  WXYCapp
//
//  Created by Jake Bromberg on 1/31/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "XYCLivePlaylistDelegate.h"
#import "PlayerCell.h"
#import "PlaycutCell.h"
#import "NSObject+LivePlaylistTableViewCellMappings.h"

@implementation XYCLivePlaylistDelegate

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
	if (!(self = [super init])) return nil;
	
	_fetchedResultsController = fetchedResultsController;
	
	NSError *error;
	BOOL success = [_fetchedResultsController performFetch:&error];
	
	if (error || !success)
	{
		NSLog(@"%@", error);
	}
	
	return self;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] lastObject] numberOfObjects];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
	PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PlayerCell class])];
	header.bounds = cell.bounds;
	[header addSubview:cell];
	
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LivePlaylistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self identifierForCellAtIndexPath:indexPath] forIndexPath:indexPath];
	
	cell.entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self classOfCellAtIndexPath:indexPath] height];
}

- (Class)classOfCellAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.fetchedResultsController objectAtIndexPath:indexPath] correspondingTableViewCellClass];
}

- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath
{
	return NSStringFromClass([self classOfCellAtIndexPath:indexPath]);
}

@end
