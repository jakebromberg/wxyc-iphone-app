//
//  FavoritesTableViewController.h
//  WXYCapp
//
//  Created by Jake on 10/19/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface FavoritesTableViewController : UITableViewController
{
	NSManagedObjectContext *managedObjectContext;
	NSNotificationCenter *dnc;
	NSFetchRequest *request;

	int selectedRow;
}

@property (nonatomic, strong) NSMutableArray *favoritesArray; //necessary or else we assign favoritesArray a CFArray type

@end
