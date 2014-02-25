//
//  BCNCoreDataManager.m
//  Transictures
//
//  Created by Hermes on 24/02/14.
//  Copyright (c) 2014 Hermes Pique. All rights reserved.
//

#import "BCNCoreDataManager.h"
#import "BCNPicture.h"

NSString *const BCNCoreDataManagerObjectsDidChangeNotification = @"BCNCoreDataManagerObjectsDidChange";

@interface BCNCoreDataManager()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation BCNCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedManager
{
    static BCNCoreDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BCNCoreDataManager new];
    });
    return instance;
}

#pragma mark Core Data stack

- (id)init
{
    self = [super init];
    if (self)
    {
        {
            NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Transictures" withExtension:@"momd"];
            _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        }
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        {
            NSURL *documentsURL = [BCNCoreDataManager documentsDirectory];
            NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"Transictures.sqlite"];
            
            NSError *error = nil;
            _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
            
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                           configuration:nil
                                                                     URL:storeURL
                                                                 options:nil
                                                                   error:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                abort();
            }
        }
        {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
            [notificationCenter addObserver:self selector:@selector(objectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:_managedObjectContext];
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:_managedObjectContext];
}

- (void)saveContext
{
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark Notifications

- (void)objectsDidChangeNotification:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BCNCoreDataManagerObjectsDidChangeNotification object:self userInfo:nil];
}

#pragma mark Pictures

- (NSArray*)fetchPictures
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Picture"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(date)) ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error = nil;
    NSArray *objects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSAssert(objects, @"Fetch %@ failed with error %@", fetchRequest, error.localizedDescription);
    return objects;
}

- (void)insertPictureWithImage:(UIImage*)image
{
    BCNPicture *picture = [NSEntityDescription insertNewObjectForEntityForName:@"Picture" inManagedObjectContext:_managedObjectContext];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    picture.imageData = imageData;
    picture.date = [NSDate date];
    [self saveContext];
}

#pragma mark Utils

+ (NSURL *)documentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
