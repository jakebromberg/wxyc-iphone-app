//
//  WXYCDataStack.m
//  WXYCapp
//
//  Created by Jake on 10/27/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "WXYCDataStack.h"
#import "WXYCAppDelegate.h"

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
	
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
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
	
	NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error]) {
		NSLog(@"Error: %@, %@", error, [error userInfo]);
    }    

    return _persistentStoreCoordinator;
}

- (NSURL *)storeURL
{
	return [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WXYC.sqlite"]];
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

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
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
