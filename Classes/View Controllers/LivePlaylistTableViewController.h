//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "PullToRefreshTableViewController.h"

@interface LivePlaylistTableViewController : UITableViewController<UITableViewDataSource, UITabBarControllerDelegate>
{
	NSIndexSet *indicesOfPlaycuts;
	int selectedRow;
}

@property NSUInteger maxEntriesToDisplay;

@end
