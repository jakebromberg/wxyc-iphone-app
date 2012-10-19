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

- (void) addBackground
{
	CGRect asdf = self.frame;
	asdf.size.height = 22.0f;
	self.frame = asdf;
	self.bounds = asdf;
	UIView *background = [[UIView alloc]
						  initWithFrame:asdf];
	background.backgroundColor = [UIColor lightGrayColor];
	self.backgroundView = background;
}

- (void) addText:(NSString *) text
{
	UILabel *label = [[UILabel alloc]
					  initWithFrame:CGRectMake( 10, 2.5f, 300, 16 )];
	label.text = text;
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.textAlignment = UITextAlignmentLeft;
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:15];
	label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.55];
    label.shadowOffset = CGSizeMake(0, -.66f);
	[self addSubview:label];
}

+ (float)height {
	return 21.0f;
}

- (id)initWithEntity:(NSManagedObject *)entity {
	if (!(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] description]]))
		return nil;

	[self setSelectionStyle:UITableViewCellSelectionStyleNone];
	[self setEntity:entity];
	[self addBackground];

	return self;
}

@end