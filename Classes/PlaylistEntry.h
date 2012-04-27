//
//  PlaylistEntry.h
//  WXYCapp
//
//  Created by Jake on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Playlist;

@interface PlaylistEntry :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * playlistEntryID;
@property (nonatomic, retain) NSNumber * chronOrderID;
@property (nonatomic, retain) NSNumber * hour;
@property (nonatomic, retain) Playlist * belongsToPlaylist;

@end



