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
#import "WebViewController.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "NSString+Additions.h"
#import "PlaycutCellButton.h"

@interface PlaycutCell ()

@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *albumArt;
@property (nonatomic, weak) IBOutlet UIView *shareBar;

@property (nonatomic, weak) IBOutlet PlaycutCellButton *twitterButton;
@property (nonatomic, weak) IBOutlet PlaycutCellButton *facebookButton;
@property (nonatomic, weak) IBOutlet PlaycutCellButton *favoriteButton;

@property (nonatomic, setter = isShareBarVisible:) BOOL isShareBarVisible;

- (IBAction)favorite:(id)sender;
- (IBAction)search:(id)sender;

@end

@implementation PlaycutCell

- (instancetype)initWithEntity:(NSManagedObject *)entity
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

	self.artistLabel.text = [entity valueForKey:@"artist"] ?: @"";
	self.titleLabel.text = [entity valueForKey:@"song"] ?: @"";
	
	if ([self.entity valueForKey:@"primaryImage"])
	{
		self.albumArt.image = [UIImage imageWithData:[self.entity valueForKey:@"primaryImage"]];
	} else {
		self.albumArt.image = [UIImage imageNamed:@"album_cover_placeholder.PNG"];
		
		__weak NSManagedObject *__entity = self.entity;
		__weak UIImageView *__albumArt = self.albumArt;
		
		SDWebImageCompletedBlock completionHandler = ^(UIImage *image, NSError *error, SDImageCacheType cacheType)
		{
			if (error)
				return;
			
			dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
			dispatch_async(backgroundQueue, ^{
				[__entity setValue:UIImagePNGRepresentation(image) forKey:@"primaryImage"];
				[[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
			});
		};
		
		OperationHandler handler = ^(NSURL *url, NSError *error) {
			[__albumArt setImageWithURL:url completed:completionHandler];
		};
		
		[GoogleImageSearch searchWithKeywords:@[self.artistLabel.text, self.titleLabel.text] handler:handler];
	}
	
	[self refreshFavoriteIcon];
}

- (void)refreshFavoriteIcon
{
	UIImage *favoriteIcon = [self favoriteIconImageForState:[[self.entity valueForKey:@"favorite"] isEqual:@(YES)]];
	[self.favoriteButton setImage:favoriteIcon forState:UIControlStateNormal];
}

- (UIImage *)favoriteIconImageForState:(BOOL)state
{
	NSString *imageName = state ? @"favorites-share-favorited.png" : @"favorites-share.png";
	
	return [UIImage imageNamed:imageName];
}

#pragma - share stuff

- (IBAction)favorite:(id)sender
{
	if ([[self.entity valueForKey:@"favorite"] isEqual:@YES])
		[UIAlertView alertViewWithTitle:nil message:@"Unlove this track, for real?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Unlove"] onDismiss:^(int buttonIndex)
		 {
			 [self.entity setValue:@NO forKey:@"favorite"];
			 [self.entity.managedObjectContext saveToPersistentStoreAndWait];
			 [self refreshFavoriteIcon];
		 } onCancel:^{
			 
		 }];
	else
	{
		[self.entity setValue:@YES forKey:@"favorite"];
		[self.entity.managedObjectContext saveToPersistentStoreAndWait];
		[self refreshFavoriteIcon];
	}
}

- (IBAction)search:(id)sender
{
	NSString *url = [@"http://google.com/search?q=%@+%@" formattedWith:@[[self.titleLabel.text urlEncodeUsingEncoding:NSUTF8StringEncoding], [self.artistLabel.text urlEncodeUsingEncoding:NSUTF8StringEncoding]]];
	WebViewController *webViewController = [[WebViewController alloc] init];
	[self.window.rootViewController presentViewController:webViewController animated:YES completion:nil];
	[webViewController loadURL:[NSURL URLWithString:url]];
}

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
