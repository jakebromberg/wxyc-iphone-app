//
//  XYCSimpleTableViewDelegate.m
//  WXYCapp
//
//  Created by Jake Bromberg on 1/31/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "XYCLivePlaylistDelegate.h"
#import "PlayerCell.h"
#import "PlaycutCell.h"
#import "Playcut.h"
#import "NSObject+LivePlaylistTableViewCellMappings.h"
#import "WXYC-Swift.h"

@interface XYCLivePlaylistDelegate ()

@property (nonatomic, strong, readwrite) UIImageView *cellArtSnapshot;

@end


@implementation XYCLivePlaylistDelegate

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
	if (!(self = [super init])) return nil;
	
	_fetchedResultsController = fetchedResultsController;
	
	NSError *error;
	BOOL success = [_fetchedResultsController performFetch:&error];
	
	if (error || !success)
	{
		NSLog(@"%@", error);
	}
	
	return self;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[PlayerHeader alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LivePlaylistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self identifierForCellAtIndexPath:indexPath] forIndexPath:indexPath];
    
    cell.entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self classOfCellAtIndexPath:indexPath] height];
}

- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath {
	return NSStringFromClass([self classOfCellAtIndexPath:indexPath]);
}

- (Class)classOfCellAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.fetchedResultsController objectAtIndexPath:indexPath] correspondingTableViewCellClass];
}

@end
