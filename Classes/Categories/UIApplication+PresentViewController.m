//
//  UIApplication+PresentViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/15/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "UIApplication+PresentViewController.h"

@implementation UIApplication (PresentViewController)

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
	[[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:viewController animated:YES completion:nil];
}

@end
