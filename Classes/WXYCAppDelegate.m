//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "WXYCAppDelegate.h"
#import "PlaylistController.h"
#import "WXYCDataStack.h"
#import "Playcut.h"
//#import "SA_OAuthTwitterEngine.h"

@implementation WXYCAppDelegate

@synthesize window;
@synthesize rootController;
@synthesize livePlaylistCtrlr;

@synthesize fetchedResultsController, managedObjectContext, managedObjectModel, persistentStoreCoordinator;

NSString *myConsumerKey = @"EH1KBn2sM4EFv2KEUUAQ";
NSString *mySecret = @"3mcWBnKTl8sQlNgPSIgO42KzPYeiD1sG14pZ1WixU";

#pragma mark -
#pragma mark MGTwitterEngineDelegate methods


- (void)requestSucceeded:(NSString *)connectionIdentifier
{
    NSLog(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
}


- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    NSLog(@"Request failed for connectionIdentifier = %@, error = %@ (%@)", 
          connectionIdentifier, 
          [error localizedDescription], 
          [error userInfo]);
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got statuses for %@:\r%@", connectionIdentifier, statuses);
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got direct messages for %@:\r%@", connectionIdentifier, messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got user info for %@:\r%@", connectionIdentifier, userInfo);
}


- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got misc info for %@:\r%@", connectionIdentifier, miscInfo);
}


- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got search results for %@:\r%@", connectionIdentifier, searchResults);
}


- (void)socialGraphInfoReceived:(NSArray *)socialGraphInfo forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got social graph results for %@:\r%@", connectionIdentifier, socialGraphInfo);
}

- (void)userListsReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got user lists for %@:\r%@", connectionIdentifier, userInfo);
}

//- (void)imageReceived:(NSImage *)image forRequest:(NSString *)connectionIdentifier
//{
//    NSLog(@"Got an image for %@: %@", connectionIdentifier, image);
//    
//    // Save image to the Desktop.
//    NSString *path = [[NSString stringWithFormat:@"~/Desktop/%@.tiff", connectionIdentifier] stringByExpandingTildeInPath];
//    [[image TIFFRepresentation] writeToFile:path atomically:NO];
//}
//
//- (void)connectionFinished:(NSString *)connectionIdentifier
//{
//    NSLog(@"Connection finished %@", connectionIdentifier);
//	
//	if ([twitterEngine numberOfConnections] == 0)
//	{
//		[NSApp terminate:self];
//	}
//}

//- (void)accessTokenReceived:(OAToken *)aToken forRequest:(NSString *)connectionIdentifier
//{
//	NSLog(@"Access token received! %@",aToken);
//	
//	token = [aToken retain];
//	//	[self runTests];
//}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got an object for %@: %@", connectionIdentifier, dictionary);
}

#pragma mark -
#pragma mark Fetched results controller

- (void)handleTimer {
	//NSLog(@"Updating");
	[livePlaylistCtrlr updatePlaylist];
}

#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    
	return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WXYC.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle the error.
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	return YES;
}

-(void) applicationWillResignActive:(UIApplication *)application {
	NSLog(@"Alseep");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillResignActive" object:nil];
}


-(void) applicationDidBecomeActive:(UIApplication *)application {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if (connection == connection1) {
		NSString *dataString = [[[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding] autorelease];
		NSLog(@"%@", dataString);
		NSString *path = [[NSBundle mainBundle] pathForResource: @"jQueryInject" ofType: @"txt"];

		NSError *error = nil;
		NSString *dataSource = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

		if (dataSource == nil) {
			NSLog(@"An error occured while processing the jQueryInject file");
		}

		if (!dataString) 
			return;
		
//		if (twitterEngine.pin.length && [dataString rangeOfString: @"oauth_verifier"].location == NSNotFound) 
//			dataString = [dataString stringByAppendingFormat: @"&oauth_verifier=%@", twitterEngine.pin];
		
//		NSString *username = [twitterEngine extractUsernameFromHTTPBody:dataString];
//		NSLog(username);
//		
//		if (username.length > 0) {
//			[[twitterEngine class] setUsername:username password:nil];
//			//		if ([_delegate respondsToSelector: @selector(storeCachedTwitterOAuthData:forUsername:)]) 
//			//			[(id) _delegate storeCachedTwitterOAuthData: dataString forUsername: username];
//		}
//		
//		//	[_accessToken release];
//		token = [[OAToken alloc] initWithHTTPResponseBody:dataString];
		
		[responseData setLength:0];
	}
}

#pragma mark -

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
//	responseData = [[NSMutableData data] retain];
//	twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
////	[twitterEngine setUsesSecureConnection:YES];
//	[twitterEngine setUsername:@"jakebromberg" password:@"Wintermute86"];
//	[twitterEngine setConsumerKey:myConsumerKey];
//	[twitterEngine setConsumerSecret:mySecret];
//	[twitterEngine requestRequestToken];
//	NSURLRequest *authorizeURLRequest = [twitterEngine authorizeURLRequest];
//	connection1 = [[NSURLConnection alloc] initWithRequest:authorizeURLRequest delegate:self];
//	[twitterEngine sendUpdate:@"testing123"];
//	NSLog(@"OAuthSetup %i", [twitterEngine OAuthSetup]);

	[window addSubview:rootController.view];
	[window makeKeyAndVisible];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

	WXYCDataStack *ds = [WXYCDataStack sharedInstance];
	[ds setStoreURL:[NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WXYC.sqlite"]]];
	
	NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}	
	
	//Clean out old data from previous launch
    if (managedObjectContext != nil) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Favorite == %@) || (Favorite == %@)", nil, @NO];	
		
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Playcut" inManagedObjectContext:managedObjectContext];
		[request setEntity:entity];
		[request setPredicate:predicate];
		
		NSLog(@"LivePlaylistTableViewController");
		
		NSArray *fetchResults = nil;
		NSError *error = nil;
		if ((fetchResults = [managedObjectContext executeFetchRequest:request error:&error])) {
			NSLog(@"fetchResults: %@", fetchResults);
			for(Playcut *cut in fetchResults) {
				[managedObjectContext deleteObject:cut];
			}
		} else {
			NSLog(@"Error %@", error);
		}		
		
		
		
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle the error.
        } 
    }

	

	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	
	NSError *setCategoryError = nil;
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
	if (setCategoryError) { /* handle the error condition */ }
	
	NSError *activationError = nil;
	[audioSession setActive:YES error:&activationError];
	if (activationError) {
		/* handle the error condition */ 
	}
	
	NSURL* url = [NSURL URLWithString:@"http://localhost/~jake/"];
	livePlaylistCtrlr = [[PlaylistController alloc] initWithBaseURL:url];
//	[livePlaylistCtrlr fetchPlaylist];
	
//	NSTimer *updatePlaylist;
//	updatePlaylist = [NSTimer scheduledTimerWithTimeInterval: 30
//													  target: livePlaylistCtrlr
//													selector: @selector(updatePlaylist)
//													userInfo: nil
//													 repeats: YES];
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive"];
//}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"I AM TERMINATING");
	
}

- (void)dealloc {
	[rootController release];
    [window release];
    [super dealloc];
}


@end
