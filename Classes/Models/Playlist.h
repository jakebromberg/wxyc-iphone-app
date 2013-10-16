//
//  Playlist.h
//  WXYCapp
//
//  Created by Jake Bromberg on 10/15/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlaylistEntry;

@interface Playlist : NSManagedObject

@property (nonatomic, retain) NSSet *entries;
@end

@interface Playlist (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(PlaylistEntry *)value;
- (void)removeEntriesObject:(PlaylistEntry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
