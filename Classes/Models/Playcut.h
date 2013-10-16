//
//  Playcut.h
//  WXYCapp
//
//  Created by Jake Bromberg on 10/15/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PlaylistEntry.h"


@interface Playcut : PlaylistEntry

@property (nonatomic, retain) NSString * Album;
@property (nonatomic, retain) NSString * Artist;
@property (nonatomic, retain) NSNumber * Favorite;
@property (nonatomic, retain) NSString * Label;
@property (nonatomic, retain) NSData * PrimaryImage;
@property (nonatomic, retain) NSNumber * Request;
@property (nonatomic, retain) NSNumber * Rotation;
@property (nonatomic, retain) NSString * Song;

@end
