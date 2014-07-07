//
//  XYCAlbumArtDownloadOperation.m
//  WXYCapp
//
//  Created by Jake Bromberg on 6/29/14.
//  Copyright (c) 2014 WXYC. All rights reserved.
//

#import "XYCAlbumArtDownloadOperation.h"
#import "GoogleImageSearch.h"
#import "SDWebImageDownloader.h"

@interface XYCAlbumArtDownloadOperation ()

@property (nonatomic, assign) XYCAlbumArtDownloaderOptions options;
@property (nonatomic, strong) XYCAlbumArtDownloaderProgressBlock progressBlock;
@property (nonatomic, strong) XYCAlbumArtDownloaderCompletedBlock completedBlock;

@property (nonatomic, strong) GoogleImageSearch *imageSearch;
@property (nonatomic, strong) id<SDWebImageOperation> imageDownloadOperation;

@end


@implementation XYCAlbumArtDownloadOperation

- (instancetype)initWithKeywords:(NSArray *)keywords options:(XYCAlbumArtDownloaderOptions)options progress:(XYCAlbumArtDownloaderProgressBlock)progressBlock completed:(XYCAlbumArtDownloaderCompletedBlock)completedBlock
{
	if (!(self = [super init])) return nil;
	
	_options = options;
	_progressBlock = progressBlock;
	_completedBlock = completedBlock;
	
	__block __typeof(self) wSelf = self;
	
	_imageSearch = [[GoogleImageSearch alloc] initWithKeywords:keywords completionHandler:^(NSURL *imageURL, NSError *error)
	{
		__typeof(self) sSelf = wSelf;
		
		if (error)
			sSelf.completedBlock(nil, nil, error, NO);
		
		_imageDownloadOperation = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageURL options:sSelf.options progress:sSelf.progressBlock completed:sSelf.completedBlock];
	}];
	
	return self;
}

- (void)cancel
{
	[self.imageSearch cancel];
	[self.imageDownloadOperation cancel];
}

@end
