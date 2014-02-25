//
//  BCNPicture.h
//  Transictures
//
//  Created by Hermes on 24/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BCNPicture : NSManagedObject

@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSDate * date;

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *dateString;

@end
