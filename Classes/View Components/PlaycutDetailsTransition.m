//
//  PlaycutDetailsTransition.m
//  WXYCapp
//
//  Created by Jake on 1/17/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "PlaycutDetailsTransition.h"

@implementation PlaycutDetailsTransition

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PlaycutDetailsTransitionAnimator alloc] init];
}

@end


@implementation PlaycutDetailsTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .25;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [[transitionContext containerView] addSubview:toView];
    toView.frame = CGRectOffset(toView.frame, 0, toView.frame.size.height);
    
    [UIView animateWithDuration:.25 animations:^{
        toView.frame = (CGRect) { CGPointZero, toView.frame.size };
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];

}

@end