//
//  PlaycutCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "PlaycutCell.h"
#import "GoogleImageSearch.h"
#import "UIImageView+WebCache.h"
#import "PlaycutCellButton.h"
#import "NSObject+KVOBlocks.h"

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

@property (nonatomic, strong) Playcut *entity;
@property (nonatomic, getter = isShareBarVisible) BOOL shareBarVisible;

#pragma mark Syntactic Sugar

@property (nonatomic, readonly) SDWebImageCompletedBlock downloadImageBlock;
@property (nonatomic, readonly) OperationHandler googleImageSearchHandler;
@property (nonatomic, readonly) UIImage *imageForAlbumArt;

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
			__self.albumArt.image = [__self imageForAlbumArt];
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
	} else {
		[GoogleImageSearch searchWithKeywords:@[self.artistLabel.text, self.titleLabel.text] completionHandler:self.googleImageSearchHandler];

		return [UIImage imageNamed:@"album_cover_placeholder.PNG"];
	}
}

- (OperationHandler)googleImageSearchHandler
{
	return ^(NSURL *url, NSError *error) {
		[[SDWebImageDownloader sharedDownloader]
		 downloadImageWithURL:url
					  options:SDWebImageRetryFailed
					 progress:nil
					completed:self.imageDownloadHandler];
	};
}

- (SDWebImageDownloaderCompletedBlock)imageDownloadHandler
{
	static dispatch_queue_t backgroundQueue;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
	});
	
	__weak __typeof(self) __self = self;

	return ^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
		if (error || !finished)
			return;
		
		dispatch_async(backgroundQueue, ^{
			__self.entity.PrimaryImage = UIImagePNGRepresentation(image);
			[[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
		});
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
	[self.albumArt cancelCurrentImageLoad];
	self.albumArt.image = nil;
}

- (void)dealloc
{
	[self removeBlockObservers];
}

#pragma initializer stuff

+ (float)height
{
	return 380.f;
}

@end
