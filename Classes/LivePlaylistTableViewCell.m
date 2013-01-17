//
//  LivePlaylistTableViewCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "LivePlaylistTableViewCell.h"

@implementation LivePlaylistTableViewCell

+ (float)height
{
	return 44.0f;
}

- (id)initWithEntity:(NSManagedObject *)entity
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end