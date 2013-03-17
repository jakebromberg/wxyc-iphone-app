//
//  WXYCDataStack.m
//  WXYCapp
//
//  Created by Jake on 10/27/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "WXYCDataStack.h"
#import "WXYCAppDelegate.h"
#import "Playcut.h"

@interface WXYCDataStack ()

@property (nonatomic, strong) NSString *applicationDocumentsDirectory;

@end

@implementation WXYCDataStack

static WXYCDataStack *sharedInstance = nil;

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */

- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil)
        return _managedObjectContext;
	
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    
	if (coordinator)
	{
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
		_managedObjectContext.persistentStoreCoordinator = coordinator;
    }
	
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel)
        return _managedObjectModel;
	
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Playlist1.0" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
	return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
        return _persistentStoreCoordinator;
	
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	
	NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error]) {
		NSLog(@"Error: %@, %@", error, [error userInfo]);
    }    

    return _persistentStoreCoordinator;
}

- (NSURL *)storeURL
{
	return [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WXYC7.sqlite"]];
}

#pragma mark - Singleton methods

+ (WXYCDataStack*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[WXYCDataStack alloc] init];
    }
	
    return sharedInstance;
}

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

- (void)purgeObsoleteEntries
{
	if (_managedObjectContext)
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Favorite == %@) || (Favorite == %@)", nil, @NO];
		
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playcut" inManagedObjectContext:_managedObjectContext];
		[request setEntity:entity];
		[request setPredicate:predicate];
		
		NSArray *fetchResults = nil;
		NSError *error = nil;
		if ((fetchResults = [_managedObjectContext executeFetchRequest:request error:&error])) {
			for(Playcut *cut in fetchResults) {
				[_managedObjectContext deleteObject:cut];
			}
		} else {
			NSLog(@"Error %@", error);
		}
		
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
			// Handle the error.
        }
    }
}

#pragma - singleton stuff

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
			sharedInstance.storeURL = [NSURL fileURLWithPath:[sharedInstance.applicationDocumentsDirectory stringByAppendingPathComponent: @"WXYC.sqlite"]];

            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
