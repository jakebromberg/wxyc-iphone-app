//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "LivePlaylistTableViewController.h"
#import "NSObject+LivePlaylistTableViewCellMappings.h"

#import "PlayerCell.h"
#import "BreakpointCell.h"
#import "TalksetCell.h"
#import "PlaycutCell.h"

@interface LivePlaylistTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation LivePlaylistTableViewController

+ (void)initialize
{
	[[UITableViewCell appearanceWhenContainedIn:[self class], nil] setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - UITableViewController

- (void)awakeFromNib
{
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    
    
	const NSArray *cellClasses = @[
		PlayerCell.class,
		PlaycutCell.class,
		TalksetCell.class,
		BreakpointCell.class,
	];
	
	for (Class cellClass in cellClasses)
	{
		NSString *className = NSStringFromClass(cellClass);
		UINib *nib = [UINib nibWithNibName:className bundle:nil];
		
		[self.tableView registerNib:nib forCellReuseIdentifier:className];
	}
	
	self.tableView.estimatedRowHeight = 360.f;
	self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 78.0f;
    self.tableView.sectionHeaderHeight = 78.f;
}

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[NSManagedObjectContext rootSavingContext] sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    if (error)
    {
        NSLog(@"%@", error);
    }
}

- (NSFetchRequest *)fetchRequest
{
    static NSFetchRequest *fetchRequest;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@keypath(PlaylistEntry *, chronOrderID) ascending:NO]];
    });
    
    return fetchRequest;
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

#pragma mark - Properties

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
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
