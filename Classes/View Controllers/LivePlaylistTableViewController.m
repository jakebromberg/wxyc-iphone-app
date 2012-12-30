//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "LivePlaylistTableViewController.h"
#import "WXYCAppDelegate.h"
#import "LoadPreviousEntriesCell.h"
#import "PlaylistController.h"
#import "PlaycutViewController.h"
#import "WXYCDataStack.h"
#import "PlaycutCell.h"
#import "NextPrevDetailsDelegate.h"

@interface LivePlaylistTableViewController () {
	NSManagedObjectContext *managedObjectContext;
	NSNotificationCenter *dnc;	
	NSFetchRequest *request;
	NSUInteger maxEntriesToDisplay;
	LoadPreviousEntriesCell *footerCell;
}

@end

@implementation LivePlaylistTableViewController

@synthesize maxEntriesToDisplay;
static const int kNumEntriesToFetch = 20;
//static int entriesMultiplier = 1;

PlaylistController* livePlaylistCtrl;

- (void)controllerContextDidSave:(NSNotification *)aNotification
{
	[managedObjectContext mergeChangesFromContextDidSaveNotification:aNotification];
	
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	[self reloadTableViewDataSource];
}

#pragma mark RefreshHeaderView

- (void) reloadTableViewDataSource {
	[livePlaylistCtrl updatePlaylist];
}

- (void)livePlaylistControllerStateChanged:(NSNotification *)aNotification
{	
	if (livePlaylistCtrl.state == LP_DONE)
	{
		refreshHeaderView.lastUpdatedDate = [NSDate date];
		[super dataSourceDidFinishLoadingNewData];
	}
}

#pragma mark -
#pragma mark UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([livePlaylistCtrl.playlist count] == 0) {
		return 0;
	}
	
	if ([self maxEntriesToDisplay] >= livePlaylistCtrl.playlist.count)
		maxEntriesToDisplay = livePlaylistCtrl.playlist.count;

	return [self maxEntriesToDisplay]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger row = [indexPath row];

	UITableViewCell* cell;
	
	if (row == [self maxEntriesToDisplay])
	{
		cell = [[LoadPreviousEntriesCell alloc] init];
	} else {
		NSManagedObject *playlistEntry = (livePlaylistCtrl.playlist)[row];
		NSString *entryType = [NSString stringWithFormat:@"%@Cell", playlistEntry.class.description];

		cell = (LivePlaylistTableViewCell*) [tableView dequeueReusableCellWithIdentifier:entryType];
		
		if (cell) {
			((LivePlaylistTableViewCell*)cell).entity = playlistEntry;
		} else {
			Class class = NSClassFromString(entryType);
			
			if (class != nil) {
				cell = [[class alloc] initWithEntity:playlistEntry];
			} else {
				cell = [[LivePlaylistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"unknown"];
			}
		}
		
		((LivePlaylistTableViewCell*)cell).delegate = self;
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//boundary case
	if (indexPath.row > ([self maxEntriesToDisplay]))
	{
		return 0;	
	}
	
	return [[[self tableView:tableView cellForRowAtIndexPath:indexPath] class] height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	selectedRow = [indexPath row];
	
	if (self.reloading) //we'll crash if we do anything while the table's (re)loading
	{
		UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
		[cell setSelected:NO animated:YES];
		return;
	}
	
	LivePlaylistTableViewCell* cell = (LivePlaylistTableViewCell*) [self.tableView cellForRowAtIndexPath:indexPath];
	if([cell class] == [PlaycutCell class]) {
//		PlaycutDetailsViewController *detailsViewController = [[PlaycutDetailsViewController alloc] init];
//		[detailsViewController setEntity:[(PlaycutCell*)cell entity]];
		PlaycutViewController *playcutView = [[PlaycutViewController alloc] init];
	}
	
//	if ([indexPath row] == [self maxEntriesToDisplay]) { //"Previously, on WXYC..."
//		LoadPreviousEntriesCell *buttonCell = (LoadPreviousEntriesCell*) [tableView cellForRowAtIndexPath:indexPath];
//		
//		if ([buttonCell.activity isAnimating]) {
//			buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//			return;
//		}
//		
//		maxEntriesToDisplay = ++entriesMultiplier*kNumEntriesToFetch;
//		
//		return;
//	}
	
	//By process of elimination, we've selected a playcut cell
//	PlaycutViewController *detail = [[[PlaycutViewController alloc] initWithNibName:@"DetailsView" bundle:nil] autorelease];
//	[detail setDelegate:self];
//	detail.hidesBottomBarWhenPushed = YES;
//	[[self navigationController] pushViewController:detail animated:YES];
	
//	indicesOfPlaycuts = [[livePlaylistCtrl.playlist indexesOfObjectsPassingTest:test] mutableCopy];
}

#pragma mark -
#pragma mark UIViewController
- (void)viewDidLoad
{
	[super viewDidLoad];

	maxEntriesToDisplay = kNumEntriesToFetch;
	
	managedObjectContext = WXYCDataStack.sharedInstance.managedObjectContext;
	
	WXYCAppDelegate *appDelegate = (WXYCAppDelegate *)[UIApplication sharedApplication].delegate;
	livePlaylistCtrl = [appDelegate livePlaylistCtrlr];

	if ((livePlaylistCtrl == nil) || [self reloading]) {
		livePlaylistCtrl = [[PlaylistController alloc] init];
		[self showReloadAnimationAnimated:YES];
		[self reloadTableViewDataSource];
	} else {
		[self reloadTableViewDataSource];
	}
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(livePlaylistControllerStateChanged:)
	 name:LPStatusChangedNotification
	 object:nil];	
	
	[refreshHeaderView setLastUpdatedDate:[NSDate date]];
}

- (void)viewDidUnload {
	[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
}

#pragma mark -
#pragma mark NextPrevDetailsDelegate business
//TODO: figure out why indicesOfPlaycuts defaults to nil at odd times
//in the meantime we're using [livePlaylistCtrl.playlist indexesOfObjectsPassingTest:test]
//to reference indices.
- (BOOL (^)(id obj, NSUInteger idx, BOOL *stop)) test
{
	id asdf = ^(id obj, NSUInteger idx, BOOL *stop)
	{
		return ([obj class] == [Playcut class]);
	};
	
	return asdf;
}

-(id)NPnext
{
	selectedRow = [[livePlaylistCtrl.playlist indexesOfObjectsPassingTest:self.test] indexGreaterThanIndex:selectedRow];

	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] 
								animated:NO 
						  scrollPosition:UITableViewScrollPositionMiddle ];

	return [self NPcurrent];
}

-(id)NPprev
{
	selectedRow = [[livePlaylistCtrl.playlist indexesOfObjectsPassingTest:self.test] indexLessThanIndex:selectedRow];

	[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] 
								animated:NO scrollPosition:UITableViewScrollPositionMiddle ];

	return [self NPcurrent];	
}

-(id)NPcurrent
{
	Playcut* playcut = [livePlaylistCtrl.playlist objectAtIndex:selectedRow];
	
	NSPredicate *predicate = [NSPredicate
							  predicateWithFormat:@"(Artist == %@) AND (Song == %@)",
							  [playcut valueForKey:@"artist"], [playcut valueForKey:@"song"]];

	request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playcut" inManagedObjectContext:managedObjectContext];
 	[request setEntity:entity];
	[request setPredicate:predicate];
	
	NSArray *fetchResults = nil;
	NSError *error = nil;
	if ((fetchResults = [managedObjectContext executeFetchRequest:request error:&error])) {
		if ([fetchResults count]) {
			return [fetchResults objectAtIndex:0];
		} 
	} else {
		NSLog(@"Error %@", error);
	}
	
	return [livePlaylistCtrl.playlist objectAtIndex:selectedRow];
}

-(BOOL)hasNext {
	return ([[livePlaylistCtrl.playlist indexesOfObjectsPassingTest:self.test] indexGreaterThanIndex:selectedRow] != NSNotFound);
}

-(BOOL)hasPrev {
	return ([[livePlaylistCtrl.playlist indexesOfObjectsPassingTest:self.test] indexLessThanIndex:selectedRow] != NSNotFound);
}

@end