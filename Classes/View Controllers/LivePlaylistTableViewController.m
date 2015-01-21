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

@interface LivePlaylistTableViewController ()

@property (nonatomic, strong, readwrite) UIImageView *cellArtSnapshot;
@property (nonatomic, readonly) NSArray *playlist;
@property (nonatomic, strong) PlaycutDetailsTransition *transition;

@end

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
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	PlaylistController *ctrlr = [PlaylistController sharedObject];
	
	[ctrlr observeKeyPath:@keypath(ctrlr, playlistEntries) changeBlock:^(NSDictionary *change) {
        if ([change[NSKeyValueChangeNewKey] count] == 0)
        {
            return;
        }

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
			id newIndexPaths = [NSIndexPath indexPathsForItemsInRange:NSMakeRange(0, [change[NSKeyValueChangeNewKey] count]) section:kPlaylistSection];
			
			[self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationFade];
		}];
	}];
}

#pragma mark UITableViewDelegate

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.estimatedSectionHeaderHeight = 78.0f;
    self.cellArtSnapshot = ({
        PlaycutCell *cell = (id) [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *art = [[UIImageView alloc] initWithFrame:(CGRect) {
            .origin = [cell.albumArt.superview convertPoint:cell.albumArt.frame.origin toView:cell.window],
            .size = cell.albumArt.frame.size
        }];

        art.contentMode = cell.albumArt.contentMode;
        art.clipsToBounds = YES;
        art.image = cell.albumArt.image;
        art;
    });
    
    PlaycutDetailsViewController *vc = [[PlaycutDetailsViewController alloc] initWithNibName:nil bundle:nil];
    vc.playcut = self.playlist[indexPath.row];
    vc.transitioningDelegate = self.transition;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LivePlaylistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self identifierForCellAtIndexPath:indexPath] forIndexPath:indexPath];

	if (indexPath.section == kPlaylistSection)
	{
		NSAssert(indexPath.row < self.playlist.count, @"Index path %@ exceeds playlist count %lu", indexPath, (unsigned long)self.playlist.count);
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

- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath
{
	return NSStringFromClass([self classOfCellAtIndexPath:indexPath]);
}

#pragma mark - Properties

- (NSArray *)playlist
{
	return [[PlaylistController sharedObject] playlistEntries];
}

- (PlaycutDetailsTransition *)transition
{
    if (!_transition)
    {
        _transition = [[PlaycutDetailsTransition alloc] init];
    }
    
    return _transition;
}

@end
