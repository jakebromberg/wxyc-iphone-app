//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import "LivePlaylistTableViewController.h"
#import "PlayerCell.h"
#import "BreakpointCell.h"
#import "TalksetCell.h"
#import "PlaycutCell.h"
#import "PlaycutDetailsViewController.h"
#import "PlaylistController.h"
#import "NSObject+KVOBlocks.h"
#import "NSIndexPath+Additions.h"

@implementation LivePlaylistTableViewController

+ (void)initialize
{
	[[UITableViewCell appearanceWhenContainedIn:[self class], nil] setBackgroundColor:[UIColor clearColor]];
}

- (void)awakeFromNib
{
	NSAssert(self.tableView, @"where'd my tableView go?");

    [super awakeFromNib];
    
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
}

#pragma mark - Properties

- (NSArray *)playlist
{
	return [[PlaylistController sharedObject] playlistEntries];
}

@end
