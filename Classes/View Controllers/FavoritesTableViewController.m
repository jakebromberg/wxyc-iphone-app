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
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Favorite == %@)", @YES];
	self.favoritesArray = [Playcut findAllSortedBy:@"chronOrderID" ascending:NO withPredicate:predicate];
	
	[[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Favorite == %@)", @YES];
		self.favoritesArray = [Playcut findAllSortedBy:@"chronOrderID" ascending:NO withPredicate:predicate];
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
	return self.favoritesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlaycutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaycutCell"];
	cell.entity = _favoritesArray[indexPath.row];
    
	return cell;
}

@end
