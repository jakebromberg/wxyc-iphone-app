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

@interface PlaycutCell ()

@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *albumArt;
@property (nonatomic, weak) IBOutlet UIView *shareBar;

@property (nonatomic, setter = isShareBarVisible:) BOOL isShareBarVisible;

- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;
- (IBAction)favorite:(id)sender;
- (IBAction)search:(id)sender;

@end

@implementation PlaycutCell

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
		
		NSString *initialText = [@"Listening to \"%@\" by %@ on WXYC!" formattedWith:@[self.titleLabel.text, self.artistLabel.text]];
		[sheet setInitialText:initialText];
		[sheet addImage:self.albumArt.image];
		[sheet addURL:[NSURL URLWithString:@"http://wxyc.org/"]];
		
		[self.window.rootViewController presentViewController:sheet animated:YES completion:nil];
	}
}

- (IBAction)favorite:(id)sender
{
	
}

- (IBAction)search:(id)sender
{
	
}

#pragma - Cell Lifecycle

- (void)prepareForReuse
{
	self.isShareBarVisible = NO;
}

- (void)isShareBarVisible:(BOOL)isShareBarVisible
{
	_isShareBarVisible = isShareBarVisible;
	
	[UIView animateWithDuration:.5 animations:^{
		self.shareBar.alpha = (self.isShareBarVisible ? 1 : 0);
	}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	self.isShareBarVisible = !self.isShareBarVisible;
	
	[super setSelected:selected animated:animated];
}

#pragma initializer stuff

+ (float)height
{
	return 360.f;
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
		
		void (^completionHandler)(UIImage*, NSError*, SDImageCacheType) = ^(UIImage *image, NSError *error, SDImageCacheType cacheType)
		{
			if (!error)
				[__entity setValue:UIImagePNGRepresentation(image) forKey:@"primaryImage"];
		};
		
		void (^successHandler)(NSString*) = ^(NSString *url) {
			[self.albumArt setImageWithURL:[NSURL URLWithString:url] completed:completionHandler];
		};
		
		[GoogleImageSearch searchWithKeywords:@[self.artistLabel.text, self.titleLabel.text] success:successHandler failure:nil finally:nil];
	}
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
