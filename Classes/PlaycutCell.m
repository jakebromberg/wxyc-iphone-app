//
//  PlaycutCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "PlaycutCell.h"
#import "NSArray+Additions.h"
#import "GoogleImageSearch.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import <Social/Social.h>
#import "NSString+Additions.h"
#import "WebViewController.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface PlaycutCell ()

@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *albumArt;
@property (nonatomic, weak) IBOutlet UIView *shareBar;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@property (nonatomic, setter = isShareBarVisible:) BOOL isShareBarVisible;

- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;
- (IBAction)favorite:(id)sender;
- (IBAction)search:(id)sender;

@end

@implementation PlaycutCell

#pragma - share stuff

- (IBAction)shareOnFacebook:(id)sender
{
	[self shareForServiceType:SLServiceTypeFacebook];
}

- (IBAction)shareOnTwitter:(id)sender
{
	[self shareForServiceType:SLServiceTypeTwitter];
}

- (void)shareForServiceType:(NSString*)serviceType
{
	if ([SLComposeViewController isAvailableForServiceType:serviceType])
	{
		SLComposeViewController *sheet = [SLComposeViewController composeViewControllerForServiceType:serviceType];
		
		NSString *initialText = [@"Listening to \"%@\" by %@ on @WXYC!" formattedWith:@[self.titleLabel.text, self.artistLabel.text]];
		[sheet setInitialText:initialText];
		[sheet addImage:self.albumArt.image];
		[sheet addURL:[NSURL URLWithString:@"http://wxyc.org/"]];
		
		[self.window.rootViewController presentViewController:sheet animated:YES completion:nil];
	}
}

- (IBAction)favorite:(id)sender
{
	if ([[self.entity valueForKey:@"favorite"] isEqual:@(YES)])
		[UIAlertView alertViewWithTitle:nil message:@"Unlove this track, for real?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Unlove"] onDismiss:^(int buttonIndex)
		 {
			 [self.entity setValue:@(NO) forKey:@"favorite"];
			 [self.entity.managedObjectContext saveToPersistentStoreAndWait];
			 [self refreshFavoriteIcon];
		 } onCancel:^{
			 
		 }];
	else
	{
		[self.entity setValue:@(YES) forKey:@"favorite"];
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
}

#pragma initializer stuff

+ (float)height
{
	return 360.f;
}

- (void)refreshFavoriteIcon
{
	if ([[self.entity valueForKey:@"favorite"] isEqual:@(YES)])
		[self.favoriteButton setImage:[UIImage imageNamed:@"favorites-share-favorited.png"] forState:UIControlStateNormal];
	else
		[self.favoriteButton setImage:[UIImage imageNamed:@"favorites-share.png"] forState:UIControlStateNormal];
}

- (void)setEntity:(NSManagedObject *)entity
{
	[super setEntity:entity];
	
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
			if (!error)
				[__entity setValue:UIImagePNGRepresentation(image) forKey:@"primaryImage"];
		};
		
		void (^successHandler)(NSString*) = ^(NSString *url) {
			[__albumArt setImageWithURL:[NSURL URLWithString:url] completed:completionHandler];
		};
		
		[GoogleImageSearch searchWithKeywords:@[self.artistLabel.text, self.titleLabel.text] success:successHandler failure:nil finally:nil];
	}
	
	[self refreshFavoriteIcon];
}

- (id)initWithEntity:(NSManagedObject *)entity
{
	self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.class.description];
	
	if (self)
	{
		self.entity = entity;
	}

	return self;
}

@end
