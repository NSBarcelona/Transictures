//
//  BCNAppDelegate.m
//  Transictures
//
//  Created by Hermes on 24/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import "BCNAppDelegate.h"
#import "BCNCoreDataManager.h"
#import "BCNTableViewController.h"
#import "BCNDetailViewController.h"
#import "BCNTableViewController.h"
#import "BCNTableDetailAnimationController.h"
#import "BCNDetailTableAnimationController.h"
#import "UIViewController+hp_layoutGuideFix.h"

@interface BCNAppDelegate()<UINavigationControllerDelegate>

@end

@implementation BCNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *viewController = [BCNTableViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.delegate = self;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[BCNCoreDataManager sharedManager] saveContext];
}

#pragma mark UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    toVC.hp_topLayoutGuide = fromVC.hp_topLayoutGuide;
    if ([fromVC isKindOfClass:[BCNTableViewController class]] && [toVC isKindOfClass:[BCNDetailViewController class]])
    {
        return [BCNTableDetailAnimationController new];
    }
    else if ([fromVC isKindOfClass:[BCNDetailViewController class]] && [toVC isKindOfClass:[BCNTableViewController class]])
    {
        return [BCNDetailTableAnimationController new];
    }
    return nil;
}

@end
