//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@class PlaylistController;

@interface WXYCAppDelegate : NSObject <UIApplicationDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) PlaylistController *livePlaylistCtrlr;
@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *rootController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (weak, nonatomic, readonly) NSString *applicationDocumentsDirectory;

@end