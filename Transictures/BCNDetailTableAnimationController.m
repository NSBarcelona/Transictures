//
//  BCNDetailTableAnimationController.m
//  Transictures
//
//  Created by Hermes on 25/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import "BCNDetailTableAnimationController.h"
#import "BCNTableViewController.h"
#import "BCNDetailViewController.h"

@implementation BCNDetailTableAnimationController

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    BCNDetailViewController *fromViewController = (BCNDetailViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BCNTableViewController *toViewController = (BCNTableViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = transitionContext.containerView;
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    UITableView *tableView = toViewController.tableView;
    NSIndexPath *selectedIndexPath = toViewController.selectedIndexPath;
    CGRect cellRect = [tableView rectForRowAtIndexPath:selectedIndexPath];
    cellRect = [containerView convertRect:cellRect fromView:tableView];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
    UIView *cellReplacement = [[UIView alloc] initWithFrame:cellRect];
    cellReplacement.backgroundColor = [UIColor whiteColor];
    [containerView insertSubview:cellReplacement aboveSubview:toViewController.view];
    
    UIImageView *transitionImageView;
    {
        transitionImageView = [[UIImageView alloc] init];
        UIImageView *fromImageView = fromViewController.imageView;
        transitionImageView.contentMode = fromImageView.contentMode;
        CGRect fromImageViewRect = [containerView convertRect:fromImageView.bounds fromView:fromImageView];
        transitionImageView.frame = fromImageViewRect;
        transitionImageView.image = fromImageView.image;
        [containerView insertSubview:transitionImageView aboveSubview:cellReplacement];
    }
    UIView *transitionDateLabel;
    {
        UIView *fromDateLabel = fromViewController.dateLabel;
        transitionDateLabel = [fromDateLabel snapshotViewAfterScreenUpdates:NO];;
        CGRect fromDateLabelRect = [containerView convertRect:fromDateLabel.bounds fromView:fromDateLabel];
        transitionDateLabel.frame = fromDateLabelRect;
        [containerView insertSubview:transitionDateLabel aboveSubview:transitionImageView];
    }
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    fromViewController.view.alpha = 0;
    [UIView animateWithDuration:duration animations:^{
        {
            UIView *toImageView = cell.imageView;
            CGRect toImageViewRect = [containerView convertRect:toImageView.bounds fromView:toImageView];
            transitionImageView.frame = toImageViewRect;
        }
        {
            UIView *toDateLabel = cell.textLabel;
            CGRect toDateLabelRect = [containerView convertRect:toDateLabel.bounds fromView:toDateLabel];
            CGFloat deltaHeight = toDateLabelRect.size.height - transitionDateLabel.bounds.size.height;
            transitionDateLabel.frame = CGRectMake(toDateLabelRect.origin.x, toDateLabelRect.origin.y + deltaHeight / 2, transitionDateLabel.bounds.size.width, transitionDateLabel.bounds.size.height);
        }
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.alpha = 1;
        [cellReplacement removeFromSuperview];
        [transitionImageView removeFromSuperview];
        [transitionDateLabel removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
