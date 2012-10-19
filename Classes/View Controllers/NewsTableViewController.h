//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshTableViewController.h"


@interface NewsTableViewController : PullToRefreshTableViewController {
	NSMutableArray *blogEntries;

	NSMutableData *responseData;
	UISegmentedControl *stationNewsSegControl;

	IBOutlet UITableView *updatesTableView;
}

@property (nonatomic, strong) NSMutableArray *blogEntries;
@property (nonatomic, strong) IBOutlet UITableView *updatesTableView;

@end
