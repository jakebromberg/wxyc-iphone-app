//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "LivePlaylistTableViewController.h"
#import "PlaylistController.h"
#import "PlayerCell.h"
#import "NSIndexPath+Additions.h"
#import "NSObject+KVOBlocks.h"
#import "NSObject+LivePlaylistTableViewCellMappings.h"

typedef enum {
	kPlayerSection = 0,
	kPlaylistSection,
	kNumberOfSections
} LivePlaylistTableSections;

@interface LivePlaylistTableViewController ()

@property (nonatomic, readonly) NSArray *playlist;

@end

@implementation LivePlaylistTableViewController

+ (void)initialize
{
	[[UITableViewCell appearanceWhenContainedIn:[self class], nil] setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section)
	{
		case kPlayerSection:
			return 1;
		default:
			return self.playlist.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LivePlaylistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self classOfCellAtIndexPath:indexPath]) forIndexPath:indexPath];

	if (indexPath.section == kPlaylistSection)
	{
		NSAssert(indexPath.row < self.playlist.count, @"Index path %@ exceeds playlist count %d", indexPath, self.playlist.count);
		cell.entity = self.playlist[indexPath.row];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self classOfCellAtIndexPath:indexPath] height];
}

- (Class)classOfCellAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == kPlayerSection)
		return [PlayerCell class];
	
	return [self.playlist[indexPath.row] correspondingTableViewCellClass];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[[PlaylistController sharedObject] observeKeyPath:@keypath(PlaylistController.sharedObject, playlist) changeBlock:^(NSDictionary *change)
	{
		id newIndexPaths = [NSIndexPath indexPathsForItemsInRange:NSMakeRange(0, [change[NSKeyValueChangeNewKey] count]) section:kPlaylistSection];
		
		[self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationFade];
	}];
}

#pragma mark - Properties

- (NSArray *)playlist
{
	return [[PlaylistController sharedObject] playlist];
}

@end
