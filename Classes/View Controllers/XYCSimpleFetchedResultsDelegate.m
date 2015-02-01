//
//  XYCSimpleFetchedResultsDelegate.m
//  WXYCapp
//
//  Created by Jake Bromberg on 1/31/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "XYCSimpleFetchedResultsDelegate.h"

@implementation XYCSimpleFetchedResultsDelegate

- (instancetype)initWithTableView:(UITableView *)tableView
{
	if (!(self = [super init])) return nil;
	
	_tableView = tableView;
	
	return self;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
	NSAssert([NSThread currentThread] == [NSThread mainThread], @"[NSThread currentThread] != [NSThread mainThread]");
	
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			[self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		case NSFetchedResultsChangeUpdate:
			[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
			break;
		default:
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.tableView endUpdates];
}

@end
