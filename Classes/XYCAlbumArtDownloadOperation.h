//
//  XYCAlbumArtDownloadOperation.h
//  WXYCapp
//
//  Created by Jake Bromberg on 6/29/14.
//  Copyright (c) 2014 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XYCAlbumArtDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

@interface XYCAlbumArtDownloadOperation : NSObject

- (instancetype)initWithKeywords:(NSArray *)keywords completed:(XYCAlbumArtDownloaderCompletedBlock)completedBlock NS_DESIGNATED_INITIALIZER;
- (void)cancel;

@end
