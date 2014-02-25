//
//  BCNCoreDataManager.h
//  Transictures
//
//  Created by Hermes on 24/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BCNCoreDataManagerObjectsDidChangeNotification;

@interface BCNCoreDataManager : NSObject

+ (instancetype)sharedManager;

#pragma Core Data

- (void)saveContext;

#pragma mark Pictures

- (NSArray*)fetchPictures;

- (void)insertPictureWithImage:(UIImage*)image;

@end
