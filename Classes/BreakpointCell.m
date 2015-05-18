//
//  BreakpointTableViewCell.m
//  WXYCapp
//
//  Created by Jake on 3/1/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "BreakpointCell.h"
#import "Breakpoint.h"
#import "NSArray+Additions.h"

@interface BreakpointCell ()

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *timeView;

@end

@implementation Breakpoint (BreakpointCell)

- (NSString *)breakpointLabelString
{
	double timeSinceEpoch = [self.hour doubleValue] / 1000;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSinceEpoch];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"h:00 a";
	
	return [dateFormatter stringFromDate:date];
}

- (UIImage *)breakpointClockIcon
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"h";
	
	double timeSinceEpoch = [self.hour doubleValue] / 1000;
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSinceEpoch];
	
	return [UIImage imageNamed:[@[@"clock-", [dateFormatter stringFromDate:date], @".png"] join]];
}

@end

@implementation BreakpointCell

- (void)setEntity:(Breakpoint *)entity
{
	super.entity = entity;
	
	self.timeLabel.text = entity.breakpointLabelString;
	self.timeView.image = entity.breakpointClockIcon;
}

@end
