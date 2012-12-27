//
//  UIView+Additions.m
//  RestKit
//
//  Created by Jake Bromberg on 12/27/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

- (void)newX:(float)x
{
	self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)newY:(float)y
{
	self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)newWidth:(float)width
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)newHeight:(float)height
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

@end
