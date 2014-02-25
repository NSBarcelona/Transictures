//
//  UIViewController+hp_layoutGuideFix.m
//  Transictures
//
//  Created by Hermes on 25/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import "UIViewController+hp_layoutGuideFix.h"
#import <objc/runtime.h>

@interface HPLayoutSupport : UIView<UILayoutSupport>

- (id)initWithLength:(CGFloat)length;

@end

@implementation HPLayoutSupport {
    CGFloat _length;
}

- (id)initWithLength:(CGFloat)length
{
    self = [super init];
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = NO;
        _length = length;
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(1, _length);
}

- (CGFloat)length
{
    return _length;
}

@end

@implementation UIViewController (hp_layoutGuideFix)

- (BOOL)hp_usesTopLayoutGuideInConstraints
{
    return NO;
}

- (id<UILayoutSupport>)hp_topLayoutGuide
{
    id<UILayoutSupport> object = objc_getAssociatedObject(self, @selector(hp_topLayoutGuide));
    return object ? : self.topLayoutGuide;
}

- (void)setHp_topLayoutGuide:(id<UILayoutSupport>)hp_topLayoutGuide
{
    HPLayoutSupport *object = objc_getAssociatedObject(self, @selector(hp_topLayoutGuide));
    if (object != nil && self.hp_usesTopLayoutGuideInConstraints)
    {
        [object removeFromSuperview];
    }
    HPLayoutSupport *layoutGuide = [[HPLayoutSupport alloc] initWithLength:hp_topLayoutGuide.length];
    if (self.hp_usesTopLayoutGuideInConstraints)
    {
        [self.view addSubview:layoutGuide];
    }
    objc_setAssociatedObject(self, @selector(hp_topLayoutGuide), layoutGuide, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
