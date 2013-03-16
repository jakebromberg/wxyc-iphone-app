//
//  WXYCDataStack.h
//  WXYCapp
//
//  Created by Jake on 10/27/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface WXYCDataStack : NSObject

@property (nonatomic, strong) NSURL *storeURL;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (WXYCDataStack *)sharedInstance;
- (void)purgeObsoleteEntries;

@end
