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
#import "PlaylistMappingsManager.h"

@interface NSManagedObjectContext ()

+ (void)MR_setupCoreDataStackWithManagedObjectStore:(RKManagedObjectStore *)managedObjectStore;
+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;

@end

@implementation XYCDataStack

- (instancetype)init
{
    if (!(self = [super init])) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication] queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
     {
         [self tidyUpCoreData];
     }];
    
    [self setupRestKit];
    [self setupMagicalRecord];
    [self tidyUpCoreData];
    
	return self;
}

- (void)setupRestKit
{
	[RKManagedObjectStore setDefaultStore:[self managedObjectStore]];
	[RKObjectManager setSharedManager:[self objectManager]];
	[RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
	[PlaylistMappingsManager addResponseDescriptorsToObjectManager:[self objectManager]];
}

- (void)setupMagicalRecord
{
	RKManagedObjectStore *mos = [self managedObjectStore];
	
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:mos.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:mos.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:mos.mainQueueManagedObjectContext];
}

- (RKObjectManager *)objectManager CA_CONST
{
	static RKObjectManager *om;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		om = [RKObjectManager managerWithBaseURL:[self baseURL]];
		om.managedObjectStore = [RKManagedObjectStore defaultStore];
	});
	
	return om;
}

- (NSURL *)baseURL CA_CONST
{
	return [NSURL URLWithString:@"http://wxyc.info/"];
}

- (RKManagedObjectStore *)managedObjectStore CA_CONST
{
	static RKManagedObjectStore *mos;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^()
	{
		NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelURL]];
		mos = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
		
		NSError *error = nil;
		[mos addSQLitePersistentStoreAtPath:[self storePath] fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
		
		NSAssert(!error, @"%@", error);

		[mos createManagedObjectContexts];
	});
	
    return mos;
}

- (NSURL *)modelURL CA_CONST
{
	return [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Playlist2" ofType:@"momd"]];
}

- (NSString *)storePath CA_CONST
{
	return [RKApplicationDataDirectory() stringByAppendingPathComponent:@"WXYC78.sqlite"];
}

- (void)tidyUpCoreData
{
	//Clean out unfavorited data
	NSPredicate *p = [NSPredicate predicateWithFormat:@"%K = %@", @keypath(Playcut *, Favorite), @NO];
	[Playcut deleteAllMatchingPredicate:p];
}

@end
