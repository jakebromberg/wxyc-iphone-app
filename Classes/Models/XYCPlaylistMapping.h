//
//  PlaylistMapping.h
//  WXYCapp
//
//  Created by Jake Bromberg on 4/15/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

@protocol XYCPlaylistMapping <NSObject>

@required

+ (NSString *)entityName;
+ (NSDictionary *)attributeMappings;
+ (NSArray *)identificationAttributes;
+ (NSString *)keyPath;

@end
