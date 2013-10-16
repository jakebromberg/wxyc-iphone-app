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

@interface PlaycutCell ()

@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *albumArt;
@property (nonatomic, weak) IBOutlet UIView *shareBar;

@property (nonatomic, weak) IBOutlet PlaycutCellButton *twitterButton;
@property (nonatomic, weak) IBOutlet PlaycutCellButton *facebookButton;
@property (nonatomic, weak) IBOutlet PlaycutCellButton *favoriteButton;
@property (nonatomic, weak) IBOutlet PlaycutCellButton *searchButton;

@property (nonatomic, strong) Playcut *entity;
@property (nonatomic, getter = isShareBarVisible) BOOL shareBarVisible;

@end

@implementation PlaycutCell

- (void)setEntity:(Playcut *)playcut
{
	[super setEntity:playcut];
	
	self.twitterButton.playcut = playcut;
	self.facebookButton.playcut = playcut;
	self.favoriteButton.playcut = playcut;
	self.searchButton.playcut = playcut;
	
	self.artistLabel.text = playcut.Artist;
	self.titleLabel.text = playcut.Song;
	
	if (self.entity.PrimaryImage)
	{
		self.albumArt.image = [UIImage imageWithData:self.entity.PrimaryImage];
	} else {
		self.albumArt.image = [UIImage imageNamed:@"album_cover_placeholder.PNG"];
		
		__weak Playcut *__entity = self.entity;
		__weak UIImageView *__albumArt = self.albumArt;
		
		SDWebImageCompletedBlock completionHandler = ^(UIImage *image, NSError *error, SDImageCacheType cacheType)
		{
			if (error)
				return;
			
			dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
			dispatch_async(backgroundQueue, ^{
				__entity.PrimaryImage = UIImagePNGRepresentation(image);
				[[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
			});
		};
		
		OperationHandler handler = ^(NSURL *url, NSError *error) {
			[__albumArt setImageWithURL:url completed:completionHandler];
		};
		
		[GoogleImageSearch searchWithKeywords:@[self.artistLabel.text, self.titleLabel.text] handler:handler];
	}
}

#pragma - share stuff

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

#pragma - Cell Lifecycle

- (void)prepareForReuse
{
	self.shareBarVisible = NO;
	[self.albumArt cancelCurrentImageLoad];
	self.albumArt.image = nil;
}

#pragma initializer stuff

+ (float)height
{
	return 360.f;
}

@end
