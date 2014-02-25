//
//  UIViewController+hp_layoutGuideFix.h
//  Transictures
//
//  Created by Hermes on 25/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (hp_layoutGuideFix)

@property (nonatomic, readonly) BOOL hp_usesTopLayoutGuideInConstraints;

@property (nonatomic, strong) id<UILayoutSupport> hp_topLayoutGuide;

@end
