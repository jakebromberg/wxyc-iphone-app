//
//  ShareItemTextInputAccessoryInsertButton.m
//  WXYCapp
//
//  Created by Jake on 12/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ShareItemTextInputAccessoryInsertButton.h"


@implementation ShareItemTextInputAccessoryInsertButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	[self.layer setOpacity:.9];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	[self.layer setOpacity:1.0];
}

- (void)drawRect:(CGRect)rect {
	//draw background gradient
	UIView *gradientView = [[[UIView alloc] initWithFrame:
							 CGRectMake(rect.origin.x, 
										rect.origin.y, 
										rect.size.width, 
										rect.size.height)] 
							autorelease];
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = gradientView.bounds;
	gradient.colors = @[(id)[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor,
					   (id)[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0].CGColor];
	gradient.cornerRadius = 2.0;
	[self.layer insertSublayer:gradient atIndex:0];
	
	[self.layer setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor];

	[self.layer setCornerRadius:2.0];
	[self.layer setBorderWidth:0.5];
	[self.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:0.7] CGColor]];

	[self.layer setShadowColor:[[UIColor colorWithWhite:0.0 alpha:0.85] CGColor]];
	[self.layer setShadowOffset:CGSizeMake(.25,1)];
	[self.layer setShadowRadius:.5];
	[self.layer setShadowOpacity:1.0];
	
	[self setTitleColor:[UIColor colorWithRed:95.0/255.0 green:103.0/255.0 blue:114.0/255.0 alpha:1.0]
			   forState:UIControlStateNormal];
	[self setTitleColor:[UIColor colorWithRed:95.0/255.0 green:103.0/255.0 blue:114.0/255.0 alpha:1.0]
			   forState:UIControlStateHighlighted];
	
	//for highlighting purposes: we make the button partially transparent 
	//when the button receives a touch.
	[self.layer setBackgroundColor:[UIColor blackColor].CGColor];
}

@end
