//
//  BCNDetailViewController.m
//  Transictures
//
//  Created by Hermes on 25/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import "BCNDetailViewController.h"
#import "BCNPicture.h"
#import "UIViewController+hp_layoutGuideFix.h"

@implementation BCNDetailViewController {
    BCNPicture *_picture;
}

@synthesize imageView = _imageView;
@synthesize dateLabel = _dateLabel;

- (id)initWithPicture:(BCNPicture*)picture
{
    if (self = [super init])
    {
        _picture = picture;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage *image = _picture.image;
        _imageView.image = image;
        [self.view addSubview:_imageView];
    }
    {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _dateLabel.font = [UIFont systemFontOfSize:16];
        NSString *dateString = _picture.dateString;
        _dateLabel.text = dateString;
        [self.view addSubview:_dateLabel];
    }
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    id<UILayoutSupport> topLayoutGuide = self.hp_topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _dateLabel, topLayoutGuide);
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_imageView]-8-|" options:kNilOptions metrics:nil views:views];
        [self.view addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][_imageView(240)]-8-[_dateLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
        [self.view addConstraints:constraints];
    }
}

#pragma mark Layout Guide Fix

- (BOOL)hp_usesTopLayoutGuideInConstraints
{
    return YES;
}

@end
