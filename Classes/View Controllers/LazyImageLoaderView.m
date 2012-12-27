//
//  LazyImageLoaderViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 11/10/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "LazyImageLoaderView.h"

@interface LazyImageLoaderView ()

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation LazyImageLoaderView

@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize imageURL = _imageURL;

- (id) init
{
	return self = [super init];
}

- (id) initWithFrame:(CGRect)frame
{
	self = [[[NSBundle mainBundle] loadNibNamed:@"LazyImageLoaderView" owner:self options:nil] lastObject];
	
	if (self)
	{
		self.frame = frame;
	}

	return self;
}

- (void) setImageURL:(NSURL *)imageURL
{
//	_imageURL = imageURL;
	[self fetchImage];
}

- (void) fetchImage
{
	NSLog(@"%@", self.activityIndicatorView);
	
	@autoreleasepool {
		[_activityIndicatorView startAnimating];

		self.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:self.imageURL]];
		
		[_activityIndicatorView stopAnimating];
	}
}


@end
