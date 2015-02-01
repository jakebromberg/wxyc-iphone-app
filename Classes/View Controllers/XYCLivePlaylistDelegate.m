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
#import "NSObject+LivePlaylistTableViewCellMappings.h"
#import "Playcut.h"
#import "LivePlaylistTransitionSnaphot.h"
#import "PlaycutDetailsTransition.h"
#import "PlaycutDetailsViewController.h"

@interface XYCLivePlaylistDelegate ()

@property (nonatomic, strong, readwrite) UIImageView *cellArtSnapshot;
@property (nonatomic, strong) PlaycutDetailsTransition *transition;

@end


@implementation XYCLivePlaylistDelegate

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
	if (!(self = [super init])) return nil;
	
	_fetchedResultsController = fetchedResultsController;
	_transition = [[PlaycutDetailsTransition alloc] init];
	
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
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] lastObject] numberOfObjects];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
	PlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PlayerCell class])];
	header.bounds = cell.bounds;
	[header addSubview:cell];
	
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LivePlaylistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self identifierForCellAtIndexPath:indexPath] forIndexPath:indexPath];
	
	cell.entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self classOfCellAtIndexPath:indexPath] height];
}

- (Class)classOfCellAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.fetchedResultsController objectAtIndexPath:indexPath] correspondingTableViewCellClass];
}

- (NSString *)identifierForCellAtIndexPath:(NSIndexPath *)indexPath
{
	return NSStringFromClass([self classOfCellAtIndexPath:indexPath]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Playcut *playcut = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	if ([playcut class] != [Playcut class])
		return;
	
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
	
	self.transition.cellArtSnapshot = self.cellArtSnapshot;
	
	PlaycutDetailsViewController *vc = [[PlaycutDetailsViewController alloc] initWithNibName:nil bundle:nil];
	vc.playcut = playcut;
	vc.transitioningDelegate = self.transition;
	vc.modalPresentationStyle = UIModalPresentationFullScreen;
	
	[self.presentingViewController presentViewController:vc animated:YES completion:nil];
}

@end
