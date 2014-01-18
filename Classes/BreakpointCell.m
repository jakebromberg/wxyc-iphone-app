//
//  BreakpointTableViewCell.m
//  WXYCapp
//
//  Created by Jake on 3/1/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "BreakpointCell.h"
#import "Breakpoint.h"

@interface BreakpointCell ()

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *timeView;

@end

@implementation BreakpointCell

+ (float)height
{
	return 50.0f;
}

- (void) setEntity:(PlaylistEntry *)entity
{
	super.entity = entity;
	
	Breakpoint *breakpoint = (Breakpoint *)entity;
	
	double timeSinceEpoch = [breakpoint.hour doubleValue] / 1000;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSinceEpoch];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"h:00 a";
	
	NSString *dateString = [dateFormatter stringFromDate:date];
	self.timeLabel.text = dateString;
	
	dateFormatter.dateFormat = @"h";
	self.timeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"clock-%@.png", [dateFormatter stringFromDate:date]]];
}

@end