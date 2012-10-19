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

@property (nonatomic, strong) NSNumber * playlistEntryID;
@property (nonatomic, strong) NSNumber * chronOrderID;
@property (nonatomic, strong) NSNumber * hour;
@property (nonatomic, strong) Playlist * belongsToPlaylist;

@end



