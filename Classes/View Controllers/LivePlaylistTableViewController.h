//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

@protocol XYCSimpleTableViewDelegate <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end


@interface LivePlaylistTableViewController : UITableViewController

@end
