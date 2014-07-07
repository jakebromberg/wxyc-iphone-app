//
//  XYCAlbumArtDownloadOperation.h
//  WXYCapp
//
//  Created by Jake Bromberg on 6/29/14.
//  Copyright (c) 2014 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImageOperation.h"
#import "SDWebImageDownloader.h"

#define XYCAlbumArtOperation SDWebImageOperation
typedef SDWebImageDownloaderOptions XYCAlbumArtDownloaderOptions;
typedef SDWebImageDownloaderProgressBlock XYCAlbumArtDownloaderProgressBlock;
typedef SDWebImageDownloaderCompletedBlock XYCAlbumArtDownloaderCompletedBlock;

@interface XYCAlbumArtDownloadOperation : NSObject

- (instancetype)initWithKeywords:(NSArray *)keywords options:(XYCAlbumArtDownloaderOptions)options progress:(XYCAlbumArtDownloaderProgressBlock)progressBlock completed:(XYCAlbumArtDownloaderCompletedBlock)completedBlock NS_DESIGNATED_INITIALIZER;
- (void)cancel;

@end
