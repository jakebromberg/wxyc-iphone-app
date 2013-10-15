//
//  UIApplication+PresentViewController.h
//  WXYCapp
//
//  Created by Jake Bromberg on 10/15/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (PresentViewController)

+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

@end
