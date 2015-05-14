//
//  XYCAlbumArtDownloadOperation.m
//  WXYCapp
//
//  Created by Jake Bromberg on 6/29/14.
//  Copyright (c) 2014 WXYC. All rights reserved.
//

#import "XYCAlbumArtDownloadOperation.h"
#import "GoogleImageSearch.h"

@interface XYCAlbumArtDownloadOperation ()

@property (nonatomic, strong) GoogleImageSearch *imageSearch;
@property (nonatomic, strong) NSURLSessionDataTask *imageDownloadOperation;

@end


@implementation XYCAlbumArtDownloadOperation

- (instancetype)initWithKeywords:(NSArray *)keywords completed:(XYCAlbumArtDownloaderCompletedBlock)completedBlock
{
	if (!(self = [super init])) return nil;
	
	__block __typeof(self) wSelf = self;
	
	_imageSearch = [[GoogleImageSearch alloc] initWithKeywords:keywords completionHandler:^(NSURL *imageURL, NSError *error)
	{
		__typeof(self) sSelf = wSelf;
		
        if (error) {
            completedBlock(nil, nil, error, NO);
        }
        
        sSelf.imageDownloadOperation = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            completedBlock([UIImage imageWithData:data], data, error, YES);
        }];
	}];
	
	return self;
}

- (void)cancel
{
	[self.imageSearch cancel];
	[self.imageDownloadOperation cancel];
}

@end
