//
//  PlaycutCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "PlaycutCell.h"
//#import "GoogleImageSearch.h"
//#import "UIImageView+WebCache.h"
#import "PlaycutCellButton.h"
#import "NSObject+KVOBlocks.h"
#import "NSArray+Additions.h"
#import "XYCAlbumArtDownloadOperation.h"

@interface PlaycutCell ()

#pragma mark IBOutlet Stuff

@property (nonatomic, weak) IBOutlet UIImageView *albumArt;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *shareBar;

@property (nonatomic, weak) IBOutlet PlaycutCellButton *twitterButton;
@property (nonatomic, weak) IBOutlet PlaycutCellButton *facebookButton;
@property (nonatomic, weak) IBOutlet PlaycutCellButton *favoriteButton;
@property (nonatomic, weak) IBOutlet PlaycutCellButton *searchButton;

#pragma mark State

@property (nonatomic, strong) __block Playcut *entity;
@property (nonatomic, getter = isShareBarVisible) BOOL shareBarVisible;
@property (nonatomic, strong) XYCAlbumArtDownloadOperation *artDownloadOperation;

@end

#pragma mark -

@implementation PlaycutCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	__weak __typeof(self) __self = self;
	
	[self observeKeyPath:@keypath(self, entity.PrimaryImage) changeBlock:^(NSDictionary *change)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			__self.albumArt.image = [UIImage imageWithData:self.entity.PrimaryImage];
		});
	}];
}

- (void)setEntity:(Playcut *)playcut
{
	[super setEntity:playcut];
	
	self.twitterButton.playcut = playcut;
	self.facebookButton.playcut = playcut;
	self.favoriteButton.playcut = playcut;
	self.searchButton.playcut = playcut;
	
	self.artistLabel.text = playcut.Artist;
	self.titleLabel.text = playcut.Song;
	
	self.albumArt.image = self.imageForAlbumArt;
}

- (UIImage *)imageForAlbumArt
{
	if (self.entity.PrimaryImage)
	{
		return [UIImage imageWithData:self.entity.PrimaryImage];
	}
	
	id keywords = @[self.artistLabel.text, self.titleLabel.text];
	self.artDownloadOperation = [[XYCAlbumArtDownloadOperation alloc]
								 initWithKeywords:keywords
								 options:0
								 progress:nil
								 completed:self.downloadCompletion];
	
	return [UIImage imageNamed:@"album_cover_placeholder.PNG"];
}

- (XYCAlbumArtDownloaderCompletedBlock)downloadCompletion
{
	__block __typeof(self.entity.objectID) __objectID = self.entity.objectID;
	
	return ^(UIImage *image, NSData *data, NSError *error, BOOL finished)
	{
		if (error)
			return;
		
		Playcut *playcut = (Playcut *) [[NSManagedObjectContext contextForCurrentThread] objectWithID:__objectID];

		playcut.PrimaryImage = data;
		
		[[NSManagedObjectContext contextForCurrentThread] saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
			NSLog(@"%uc %@", success, error);
		}];
	};
}

#pragma Share stuff

- (void)setShareBarVisible:(BOOL)shareBarVisible
{
	_shareBarVisible = shareBarVisible;
	
	[UIView animateWithDuration:.5 animations:^{
		self.shareBar.alpha = (self.isShareBarVisible ? 1 : 0);
	}];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (event.type == UIEventTypeTouches)
		self.shareBarVisible = !self.isShareBarVisible;
}

#pragma Cell Lifecycle

- (void)prepareForReuse
{
	self.shareBarVisible = NO;
	[self.artDownloadOperation cancel];
}

- (void)dealloc
{
	[self removeBlockObservers];
}

#pragma initializer stuff

+ (float)height
{
	return 360.f;
}

@end
