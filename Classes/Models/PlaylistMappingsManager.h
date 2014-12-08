//
//  PlaylistMapping.h
//  WXYCapp
//
//  Created by Jake Bromberg on 4/15/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import <RestKit/RestKit.h>

@protocol XYCPlaylistMapping <NSObject>

@required

+ (NSString *)entityName;
+ (NSDictionary *)attributeMappings;
+ (NSArray *)identificationAttributes;
+ (NSString *)keyPath;

@end

@interface PlaylistMappingsManager : NSObject

+ (void)addResponseDescriptorsToObjectManager:(RKObjectManager *)objectManager;

@end