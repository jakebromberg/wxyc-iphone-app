//
//  FavoritesTableViewController.m
//  WXYCapp
//
//  Created by Jake on 10/19/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FavoritesTableViewController.h"
#import "Playcut.h"
#import "PlaycutCell.h"

@implementation FavoritesTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UINib *playcutCellNib = [UINib nibWithNibName:NSStringFromClass([PlaycutCell class]) bundle:nil];
    [self.tableView registerNib:playcutCellNib forCellReuseIdentifier:NSStringFromClass([PlaycutCell class])];
    
	self.favoritesArray = [Playcut findByAttribute:@"Favorite" withValue:@YES andOrderBy:@"chronOrderID" ascending:NO];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
	{
		self.favoritesArray = [Playcut findByAttribute:@"Favorite" withValue:@YES andOrderBy:@"chronOrderID" ascending:NO];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
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
	if (self.favoritesArray.count == 0)
	{
		tableView.scrollEnabled = NO;
		return 0;
	} else
	{
		tableView.scrollEnabled = YES;
		return self.favoritesArray.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.favoritesArray.count == 0 && indexPath.row == 0)
		return [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];

    PlaycutCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PlaycutCell class])];
	cell.entity = self.favoritesArray[indexPath.row];
    cell.selected = NO;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.favoritesArray.count == 0 && indexPath.row == 1)
	{
		self.tableView.scrollEnabled = NO;
		return 360.f;
	}

	return [PlaycutCell height];
}

@end
