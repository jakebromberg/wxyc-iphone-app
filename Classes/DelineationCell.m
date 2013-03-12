//
//  DelineationCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "DelineationCell.h"
#import <CoreData/CoreData.h>

@implementation DelineationCell

- (void) addText:(NSString *) text
{
	UILabel *label = [[UILabel alloc]
					  initWithFrame:CGRectMake( 10, 2.5f, 300, 16 )];
	label.text = text;
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.textAlignment = NSTextAlignmentLeft;
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:15];
	label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.55];
    label.shadowOffset = CGSizeMake(0, -.66f);
	[self addSubview:label];
}

+ (float)height {
	return 21.0f;
}

- (id)initWithEntity:(NSManagedObject *)entity
{
	if (!(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] description]]))
		return nil;

	self.selectionStyle = UITableViewCellSelectionStyleNone;
	self.entity = entity;

	return self;
}

@end