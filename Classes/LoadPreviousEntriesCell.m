//
//  ButtonTableViewCell.m
//  WXYCapp
//
//  Created by Jake on 3/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "LoadPreviousEntriesCell.h"


@implementation LoadPreviousEntriesCell

- (id)init
{
	self = [NSBundle.mainBundle loadNibNamed:@"LoadPreviousEntriesCell" owner:self options:nil].lastObject;

	if (self)
	{
		self.description.text = @"Previously, on WXYC…";
		self.description.textColor = [UIColor blueColor];
		self.backgroundView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
	}
	
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	if ([self.activity isAnimating])
		return;
    
	[super setSelected:selected animated:animated];

	if (selected)
	{
		[self.activity startAnimating];
		[NSTimer scheduledTimerWithTimeInterval: 0.25 target:self selector:@selector(handleTimer:) userInfo:nil repeats:NO];
	}
}

- (void) handleTimer: (NSTimer *) timer
{
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
