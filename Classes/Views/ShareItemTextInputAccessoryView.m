//
//  ShareItemTextInputAccessoryView.m
//  WXYCapp
//
//  Created by Jake on 12/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ShareItemTextInputAccessoryView.h"


@implementation ShareItemTextInputAccessoryView

- (void)drawRect:(CGRect)rect {
//	[super drawRect:rect];
	CGContextRef c = UIGraphicsGetCurrentContext();

	//draw background gradient
	UIView *gradientView = [[[UIView alloc] initWithFrame:
					 CGRectMake(rect.origin.x, 
								rect.origin.y, 
								rect.size.width, 
								rect.size.height)] 
					autorelease];
	CAGradientLayer *gradient = [CAGradientLayer layer];
	gradient.frame = gradientView.bounds;
	gradient.colors = [NSArray arrayWithObjects:
					   (id)[UIColor colorWithRed:165.0/255.0 green:173.0/255.0 blue:184.0/255.0 alpha:1.0].CGColor,
					   (id)[UIColor colorWithRed:141.0/255.0 green:149.0/255.0 blue:160.0/255.0 alpha:1.0].CGColor, 
					   nil];
	[gradient renderInContext:c];

	//draw top border
	CGFloat topBorder[4] = {58.0f/255.0f, 61.0f/255.0f, 66.0f/255.0f, 1.0f};
    CGContextSetStrokeColor(c, topBorder);
	CGContextSetLineWidth(c, 2.0);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0.0f, 0.0f);
    CGContextAddLineToPoint(c, rect.size.width, 0.0f);
    CGContextStrokePath(c);	
	
	//draw top border
	CGFloat topInsetBorder[4] = {188.0f/255.0f, 194.0f/255.0f, 201.0f/255.0f, 1.0f};
    CGContextSetStrokeColor(c, topInsetBorder);
	CGContextSetLineWidth(c, 1.0);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, 0.0f, 2.0f);
    CGContextAddLineToPoint(c, rect.size.width, 2.0f);
    CGContextStrokePath(c);	
	
//	CGGradientRef myGradient;
//	CGColorSpaceRef myColorspace;
//	size_t num_locations = 2;
//	CGFloat locations[2] = { 0.0, 1.0 };
//	CGFloat components[8] = { 165.0/255.0, 173.0/255.0, 184.0/255.0, 1.0,   // Start color
//							  141.0/255.0, 149.0/255.0, 160.0/255.0, 1.0 }; // End color
//	
//	myColorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
//	myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
//													  locations, num_locations);
//	
//	CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), myGradient, CGPointMake(0.0f, 0.0f), CGPointMake(0.0f, rect.size.height),
//								kCGGradientDrawsAfterEndLocation);
	
}

//- (id)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame])
//    {
//        _isOpen = FALSE;
//        _contentHeight = frame.size.height - gBarHeight;
//        
//        // Gradient setup for bar
//        float barColors[8] = {
//            0.30f, 0.30f, 0.30f, 0.75f,
//            0.00f, 0.00f, 0.00f, 0.75f
//        };
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        if (colorSpace != NULL)
//        {
//            _barGradient = CGGradientCreateWithColorComponents(colorSpace, barColors, NULL, 2);
//            if (_barGradient == NULL)
//                NSLog(@"Failed to create CGGradient");
//            CGColorSpaceRelease(colorSpace);
//        }
//        _barStartPoint = CGPointMake(0.0f, 0.0f);
//        _barEndPoint = CGPointMake(0.0f, gBarHeight);
//        
//        // Image setup for bar
//        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Triangle" ofType:@"png"]];
//        if (image == nil)
//            NSLog(@"Failed to load image for control vieww");
//        
//        _barImageView = [[[UIImageView alloc] initWithImage:image] autorelease];
//        CGRect imageViewFrame = _barImageView.frame;
//        imageViewFrame.origin.x = floorf((frame.size.width/2.0f) - (imageViewFrame.size.width/2.0f));
//        imageViewFrame.origin.y = floorf((gBarHeight/2.0f) - (imageViewFrame.size.height/2.0f));
//        [_barImageView setFrame:imageViewFrame];
//        
//        [self addSubview:_barImageView];
//        
//        _barImageViewRotation = CGAffineTransformMake(cos(-M_PI), sin(-M_PI), -sin(-M_PI), cos(-M_PI), 0.0f, 0.0f);
//		
//        self.opaque = FALSE;
//    }
//	
//    return self;
//}

@end
