//
//  Playcut.h
//  WXYCapp
//
//  Created by Jake on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PlaylistEntry.h"

@interface ImageToDataTransformer : NSValueTransformer { }
@end

@interface Playcut :  PlaylistEntry  
{
}

@property (nonatomic, retain) NSNumber * request;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) UIImage  * primaryImage;
@property (nonatomic, retain) NSString * song;
@property (nonatomic, retain) NSNumber * rotation;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSManagedObject * image;

@end



