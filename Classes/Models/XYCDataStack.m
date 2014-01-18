//
//  XYCDataStack.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/13/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "XYCDataStack.h"
#import <RestKit/RestKit.h>
#import "Playcut.h"

@interface NSManagedObjectContext ()

+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;

@end

@implementation XYCDataStack

- (id)init
{
	return COMMON_INIT([super init]);
}

- (void)commonInit
{
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
	 {
		 [self tidyUpCoreData];
	 }];
	
	[self configureCoreData];
	[self tidyUpCoreData];
}

- (void)configureCoreData
{
    RKManagedObjectStore *managedObjectStore = [self createManagedObjectStore];
	[self configureManagedObjectStore:managedObjectStore];
	[self configureMagicalRecordWithManagedObjectStore:managedObjectStore];
	
	RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://wxyc.info/"]];
    objectManager.managedObjectStore = managedObjectStore;
}

- (RKManagedObjectStore *)createManagedObjectStore
{
	NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Playlist2" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
	
    return [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
}

- (void)configureManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"WXYC78.sqlite"];
    NSError *error = nil;
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    [managedObjectStore createManagedObjectContexts];
}

- (void)configureMagicalRecordWithManagedObjectStore:(RKManagedObjectStore *)managedObjectStore
{
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:managedObjectStore.mainQueueManagedObjectContext];
}

- (void)tidyUpCoreData
{
	//Clean out unfavorited data
	for (Playcut *playcut in [Playcut findByAttribute:@"Favorite" withValue:@NO]) {
		[playcut deleteEntity];
	}
	
	[[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

@end
