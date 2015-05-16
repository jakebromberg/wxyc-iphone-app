//
//  PlaycutDetailsTransition.m
//  WXYCapp
//
//  Created by Jake on 1/17/15.
//  Copyright (c) 2015 WXYC. All rights reserved.
//

#import "PlaycutDetailsTransition.h"
#import "LivePlaylistTableViewController.h"
#import "PlaycutDetailsViewController.h"
#import "PlaycutCell.h"
#import "XYCRootViewController.h"

@implementation PlaycutDetailsTransition

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(LivePlaylistTableViewController *)source
{
    PlaycutDetailsTransitionAnimator *animator = [[PlaycutDetailsTransitionAnimator alloc] init];
    animator.cellArtSnaphot = self.cellArtSnapshot;

//        CGPoint newPoint = [presented.view convertPoint:animator.cellSnaphot.frame.origin
//                                    fromCoordinateSpace:source.view];
//        (CGRect) { newPoint, animator.cellSnaphot.frame.size };
//    });
    
	return animator;
}

@end


@implementation PlaycutDetailsTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return .5;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    PlaycutDetailsViewController *toVC = (id) [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromVCSnapshot;
    [[transitionContext containerView] addSubview:({
        XYCRootViewController *fromVC = (id) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromVCSnapshot = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    })];
    
    [[transitionContext containerView] addSubview:toVC.view];
    toVC.view.frame = CGRectOffset(toVC.view.frame, 0, toVC.view.frame.size.height);
    
    [[transitionContext containerView] addSubview:self.cellArtSnaphot];

    UIView *navBarSnapshot = ({
        XYCRootViewController *fromVC = (id) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *snapshot = [fromVC.navigationBar snapshotViewAfterScreenUpdates:NO];
        snapshot.frame = (CGRect) {
            .origin = [fromVC.navigationBar.window convertPoint:fromVC.navigationBar.frame.origin fromView:fromVC.view],
            .size = snapshot.frame.size,
        };
        snapshot;
    });
    [[transitionContext containerView] addSubview:navBarSnapshot];
    
    UIView *tabBarSnaphot = ({
        XYCRootViewController *fromVC = (id) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UITabBarController *tabBarController = [[fromVC childViewControllers] lastObject];
        UIView *snapshot = [tabBarController.tabBar snapshotViewAfterScreenUpdates:NO];
        snapshot.frame = (CGRect) {
            .origin = [tabBarController.tabBar.window convertPoint:tabBarController.tabBar.frame.origin fromView:tabBarController.view],
            .size = snapshot.frame.size,
        };
        snapshot;
    });
    [[transitionContext containerView] addSubview:tabBarSnaphot];

    [UIView animateWithDuration:[self transitionDuration:transitionContext] - .1 delay:.05 options:0 animations:^{
        navBarSnapshot.alpha = 0;
//        tabBarSnaphot.frame = CGRectOffset(tabBarSnaphot.frame, 0, tabBarSnaphot.frame.size.height);
        tabBarSnaphot.alpha = 0;
    } completion:^(BOOL finished) {

    }];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.frame = (CGRect) { CGPointZero, toVC.view.frame.size };
        
        self.cellArtSnaphot.frame = toVC.albumImage.frame;
    } completion:^(BOOL finished) {
        [self.cellArtSnaphot removeFromSuperview];
        [transitionContext completeTransition:YES];
        NSLog(@"%@", self.cellArtSnaphot);
    }];
}

@end
