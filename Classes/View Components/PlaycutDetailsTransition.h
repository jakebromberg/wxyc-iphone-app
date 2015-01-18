//
//  PlaycutDetailsTransition.h
//  WXYCapp
//
//  Created by Jake on 1/17/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlaycutDetailsTransitionAnimator;

@interface PlaycutDetailsTransition : NSObject <UIViewControllerTransitioningDelegate>

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

@end


@interface PlaycutDetailsTransitionAnimator : NSObject  <UIViewControllerAnimatedTransitioning>

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

@end