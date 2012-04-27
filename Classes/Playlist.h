//
//  Playlist.h
//  WXYCapp
//
//  Created by Jake on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class PlaylistEntry;

@interface Playlist :  NSManagedObject  
{
}

@property (nonatomic, retain) NSSet* containsEntries;

@end


@interface Playlist (CoreDataGeneratedAccessors)
- (void)addContainsEntriesObject:(PlaylistEntry *)value;
- (void)removeContainsEntriesObject:(PlaylistEntry *)value;
- (void)addContainsEntries:(NSSet *)value;
- (void)removeContainsEntries:(NSSet *)value;

@end

