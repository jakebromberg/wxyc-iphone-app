//
//  UIApplication+PresentViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/23/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "UIApplication+PresentViewController.h"

@implementation UIApplication (PresentViewController)

+ (void)presentViewController:(UIViewController *)viewControllerToPresent
{
	[[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:viewControllerToPresent animated:YES completion:nil];
}

@end
