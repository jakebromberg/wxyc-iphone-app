//
//  FavoritesTableViewController.h
//  WXYCapp
//
//  Created by Jake on 10/19/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NextPrevDetailsDelegate.h"
//#import "NextPrevDetailsViewController.h"


@interface FavoritesTableViewController : UITableViewController <NextPrevDetailsDelegate> {
//	IBOutlet UITableView *favoritesTableView;	
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *favoritesArray;
	NSNotificationCenter *dnc;
	NSFetchRequest *request;

	int selectedRow;
}

//@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *favoritesArray; //necessary or else we assign favoritesArray a CFArray type

@end
