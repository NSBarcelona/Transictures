//
//  BCNDetailViewController.h
//  Transictures
//
//  Created by Hermes on 25/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BCNPicture;

@interface BCNDetailViewController : UIViewController

@property (nonatomic, readonly, strong) UIImageView *imageView;
@property (nonatomic, readonly, strong) UILabel *dateLabel;

- (id)initWithPicture:(BCNPicture*)picture;

@end
