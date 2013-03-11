//
//  PlaycutCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "PlaycutCell.h"
#import "Playcut.h"
#import "NSArray+Additions.h"
#import "GoogleImageSearch.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@interface PlaycutCell ()

@property  (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property  (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property  (nonatomic, weak) IBOutlet UIImageView *albumArt;

@end

@implementation PlaycutCell

+ (float)height
{
	return 360.f;
}

- (void)setEntity:(NSManagedObject *)entity
{
	[super setEntity:entity];
	
	self.artistLabel.text = [entity valueForKey:@"artist"];
	self.titleLabel.text = [entity valueForKey:@"song"];
	
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
