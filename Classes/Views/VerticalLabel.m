//
//  VerticalLabel.m
//  WXYCapp
//
//  Created by Jake on 10/13/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "VerticalLabel.h"
#import <math.h>

@implementation VerticalLabel


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
//		super.userInteractionEnabled = YES;
		
    }
	[super setUserInteractionEnabled:YES];
	[self setUserInteractionEnabled:YES];
	
	//rotate or the label will look less than convincing
	super.transform = CGAffineTransformMakeRotation(M_PI);
	
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)viewDidLoad {
	self.transform = CGAffineTransformMakeRotation(M_PI);
	super.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)dealloc {
    [super dealloc];
}


@end
