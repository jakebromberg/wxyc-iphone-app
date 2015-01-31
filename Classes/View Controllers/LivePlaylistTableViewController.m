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

@implementation LivePlaylistTableViewController

+ (void)initialize
{
	[[UITableViewCell appearanceWhenContainedIn:[self class], nil] setBackgroundColor:[UIColor clearColor]];
}

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

@end
