//
//  BCNPicture.m
//  Transictures
//
//  Created by Hermes on 24/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import "BCNPicture.h"

@implementation BCNPicture

@dynamic imageData;
@dynamic date;

- (UIImage*)image
{
    return [UIImage imageWithData:self.imageData];
}

- (NSString*)dateString
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.dateStyle = kCFDateFormatterShortStyle;
        formatter.doesRelativeDateFormatting = YES;
        formatter.locale = [NSLocale currentLocale];
    });
    return [formatter stringFromDate:self.date];
}

@end
