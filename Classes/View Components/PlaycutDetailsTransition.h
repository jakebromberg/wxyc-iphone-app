//
//  PlaycutDetailsTransition.h
//  WXYCapp
//
//  Created by Jake on 1/17/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlaycutDetailsTransitionAnimator;
@class PlaycutCell;

@interface PlaycutDetailsTransition : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIImageView *cellArtSnapshot;

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;

@end


@interface PlaycutDetailsTransitionAnimator : NSObject  <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIImageView *cellArtSnaphot;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext;
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

@end