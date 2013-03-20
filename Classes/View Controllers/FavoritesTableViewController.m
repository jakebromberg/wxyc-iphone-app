//
//  FavoritesTableViewController.m
//  WXYCapp
//
//  Created by Jake on 10/19/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FavoritesTableViewController.h"
#import "WXYCDataStack.h"
#import "Playcut.h"
#import "PlaycutCell.h"
#import "UIAlertView+MKBlockAdditions.h"

@implementation FavoritesTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.favoritesArray = [Playcut findByAttribute:@"Favorite" withValue:@YES];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
	{
		self.favoritesArray = [Playcut findByAttribute:@"Favorite" withValue:@YES];
		[self.tableView reloadData];
	}];
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.favoritesArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
		return [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
	
    PlaycutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaycutCell"];
	cell.entity = _favoritesArray[indexPath.row - 1];
    cell.selected = NO;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0)
		return 40;
	
	return [PlaycutCell height];
}

@end
