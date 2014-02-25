//
//  BCNTableDetailAnimationController.m
//  Transictures
//
//  Created by Hermes on 25/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import "BCNTableDetailAnimationController.h"
#import "BCNTableViewController.h"
#import "BCNDetailViewController.h"

@implementation BCNTableDetailAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    BCNTableViewController *fromViewController = (BCNTableViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BCNDetailViewController *toViewController = (BCNDetailViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];

    UITableView *tableView = fromViewController.tableView;
    NSIndexPath *selectedIndexPath = tableView.indexPathForSelectedRow;
    CGRect cellRect = [tableView rectForRowAtIndexPath:selectedIndexPath];
    cellRect = [containerView convertRect:cellRect fromView:tableView];

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
    UIView *cellReplacement = [[UIView alloc] initWithFrame:cellRect];
    cellReplacement.backgroundColor = [UIColor whiteColor];
    [containerView insertSubview:cellReplacement belowSubview:toViewController.view];

    UIView *toImageView = toViewController.imageView;
    CGRect toImageViewRect = toImageView.frame;
    
    UIView *toDateLabel = toViewController.dateLabel;
    CGRect toDateLabelRect = toDateLabel.frame;
    {
        UIView *fromImageView = cell.imageView;
        CGRect fromImageViewRect = [toImageView.superview convertRect:fromImageView.bounds fromView:fromImageView];
        toImageView.frame = fromImageViewRect;
    }
    {
        UIView *fromDateLabel = cell.textLabel;
        CGRect fromDateLabelRect = [toDateLabel.superview convertRect:fromDateLabel.bounds fromView:fromDateLabel];
        toDateLabel.frame = fromDateLabelRect;
    }
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    fromViewController.view.alpha = 1;
    [UIView animateWithDuration:duration animations:^{
        toImageView.frame = toImageViewRect;
        toDateLabel.frame = toDateLabelRect;
        fromViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        fromViewController.view.alpha = 1;
        [cellReplacement removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
