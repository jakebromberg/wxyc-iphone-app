//
//  Playcut.h
//  WXYCapp
//
//  Created by Jake on 11/8/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "PlaylistEntry.h"

@interface ImageToDataTransformer : NSValueTransformer { }
@end

@interface Playcut :  PlaylistEntry  
{
}

@property (nonatomic, strong) NSNumber * request;
@property (nonatomic, strong) NSString * artist;
@property (nonatomic, strong) NSNumber * favorite;
@property (nonatomic, strong) NSString * album;
@property (nonatomic, strong) UIImage  * primaryImage;
@property (nonatomic, strong) NSString * song;
@property (nonatomic, strong) NSNumber * rotation;
@property (nonatomic, strong) NSString * label;
@property (nonatomic, strong) NSManagedObject * image;

@end



