//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "PullToRefreshTableViewController.h"
#import "LoadPreviousEntriesCell.h"

@class PlaycutDetailsViewController;
@class PlaylistController;

@interface LivePlaylistTableViewController : PullToRefreshTableViewController {
	IBOutlet UITableView *playlistTableView;
	IBOutlet UILabel *loadingLabel;
	
	NSIndexSet *indicesOfPlaycuts;
	int selectedRow;
}

@property NSUInteger maxEntriesToDisplay;

@end
