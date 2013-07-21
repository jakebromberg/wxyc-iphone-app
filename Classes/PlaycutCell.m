//
//  PlaycutCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "PlaycutCell.h"
#import "GoogleImageSearch.h"
#import <QuartzCore/QuartzCore.h>
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

@property (nonatomic, setter = isShareBarVisible:) BOOL isShareBarVisible;

@end

@implementation PlaycutCell

- (id)initWithEntity:(NSManagedObject *)entity
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.class.description];
	
	if (self)
	{
		self.entity = entity;
	}
	
	return self;
}

- (void)setEntity:(NSManagedObject *)entity
{
	[super setEntity:entity];
	
	self.twitterButton.playcut = (Playcut *)entity;
	self.facebookButton.playcut = (Playcut *)entity;
	self.favoriteButton.playcut = (Playcut *)entity;
	self.searchButton.playcut = (Playcut *)entity;

	self.artistLabel.text = [entity valueForKey:@"artist"] ?: @"";
	self.titleLabel.text = [entity valueForKey:@"song"] ?: @"";
	
	if ([self.entity valueForKey:@"primaryImage"])
	{
		self.albumArt.image = [UIImage imageWithData:[self.entity valueForKey:@"primaryImage"]];
	} else {
		self.albumArt.image = [UIImage imageNamed:@"album_cover_placeholder.PNG"];
		
		__weak NSManagedObject *__entity = self.entity;
		__weak UIImageView *__albumArt = self.albumArt;
		
		void (^completionHandler)(UIImage*, NSError*, SDImageCacheType) = ^(UIImage *image, NSError *error, SDImageCacheType cacheType)
		{
			dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NULL);
			dispatch_async(queue, ^{
				if (!error)
				{
					[__entity setValue:UIImagePNGRepresentation(image) forKey:@"primaryImage"];
					__albumArt.layer.shouldRasterize = YES;
					
					[[NSManagedObjectContext defaultContext] saveToPersistentStore:nil];
				}
			});

		};
		
		void (^successHandler)(NSString*) = ^(NSString *url) {
			[__albumArt setImageWithURL:[NSURL URLWithString:url] completed:completionHandler];
		};
		
		[GoogleImageSearch searchWithKeywords:@[self.artistLabel.text, self.titleLabel.text] success:successHandler failure:nil finally:nil];
	}
}

#pragma - share stuff

- (void)isShareBarVisible:(BOOL)isShareBarVisible
{
	_isShareBarVisible = isShareBarVisible;
	
	[UIView animateWithDuration:.5 animations:^{
		self.shareBar.alpha = (self.isShareBarVisible ? 1 : 0);
	}];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (event.type == UIEventTypeTouches)
		self.isShareBarVisible = !self.isShareBarVisible;
}

#pragma - Cell Lifecycle

- (void)prepareForReuse
{
	self.isShareBarVisible = NO;
	[self.albumArt cancelCurrentImageLoad];
	self.albumArt.image = nil;
}

#pragma initializer stuff

+ (float)height
{
	return 360.f;
}

@end
