//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol XYCSimpleTableViewDelegate <UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong, readonly) UIImageView *cellArtSnapshot;

@end


@interface LivePlaylistTableViewController : UITableViewController

@property (nonatomic, strong, readonly) UIImageView *cellArtSnapshot;

@end
