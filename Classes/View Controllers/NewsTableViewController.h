//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshTableViewController.h"


@interface NewsTableViewController : PullToRefreshTableViewController {
	NSMutableData *responseData;
	UISegmentedControl *stationNewsSegControl;
}

@property (nonatomic, strong) NSMutableArray *blogEntries;
@property (nonatomic, strong) IBOutlet UITableView *updatesTableView;

@end
