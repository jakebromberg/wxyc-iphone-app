//
//  NSFetchedResultsController+XYCViewControllers.h
//  WXYCapp
//
//  Created by Jake Bromberg on 1/31/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (XYCViewControllers)

+ (instancetype)livePlaylistFetchedResultsController;
+ (instancetype)favoritesFetchedResultsController;

@end
