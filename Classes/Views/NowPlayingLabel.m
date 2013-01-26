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
		[super setUserInteractionEnabled:YES];
		[self setUserInteractionEnabled:YES];

		//rotate or the label will look less than convincing
		super.transform = CGAffineTransformMakeRotation(M_PI);
    }
	
    return self;
}

- (void)viewDidLoad {
	self.transform = CGAffineTransformMakeRotation(M_PI);
	super.transform = CGAffineTransformMakeRotation(M_PI);
}

@end
