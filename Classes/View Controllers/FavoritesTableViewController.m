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

@implementation FavoritesTableViewController

- (void)controllerContextDidSave:(NSNotification *)aNotification
{
	[managedObjectContext mergeChangesFromContextDidSaveNotification:aNotification];
	NSLog(@"NSPredicate %@", [request predicate]);

	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}

	self.favoritesArray = mutableFetchResults;
	
	[self.tableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	managedObjectContext = [[WXYCDataStack sharedInstance] managedObjectContext];

	dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(controllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
	
	request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playcut" inManagedObjectContext:managedObjectContext];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Favorite == %@)", @YES];
	request.entity = entity;
	request.predicate = predicate;
	
	// Order the events by creation date, most recent first.
//	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Artist" ascending:NO];
//	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch. Create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
		NSLog(@"mutableFetchResults error %@", error);
	}
	
	// Set self's events array to the mutable array, then clean up.
	self.favoritesArray = mutableFetchResults;
}

- (void)viewDidUnload
{
	self.favoritesArray = nil;
	[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSError *error = nil;
	NSArray *fetchResults = [managedObjectContext executeFetchRequest:request error:&error];
	if (fetchResults == nil)
	{
		// Handle the error.
	}

	return fetchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
	// Get the favorite corresponding to the current index path and configure the table view cell.
	Playcut *favorite = (Playcut *)_favoritesArray[indexPath.row];
	
	cell.textLabel.text = favorite.artist;// [dateFormatter stringFromDate:[event creationDate]];
    cell.detailTextLabel.text = favorite.song;
    
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
	
	self.navigationItem.rightBarButtonItem.enabled = !editing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[managedObjectContext deleteObject:_favoritesArray[indexPath.row]];
		[_favoritesArray removeObjectAtIndex:[indexPath row]];

		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }   
}

@end
