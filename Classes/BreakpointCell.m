//
//  BreakpointTableViewCell.m
//  WXYCapp
//
//  Created by Jake on 3/1/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "BreakpointCell.h"
#import "Breakpoint.h"
@implementation BreakpointCell

- (void) setEntity:(NSManagedObject *)entity
{
	super.entity = entity;
	
	Breakpoint* breakpoint = (Breakpoint*)entity;
	
	double timeSinceEpoch = [[NSString stringWithFormat: @"%@", [breakpoint valueForKey:@"hour"]] doubleValue] / 1000;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSinceEpoch];
	
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"h:00 a";
	
	NSString* dateString = [dateFormatter stringFromDate:date];
	[self addText:dateString];
}

@end