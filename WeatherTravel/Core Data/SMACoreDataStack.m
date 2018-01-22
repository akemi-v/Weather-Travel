//
//  SMACoreDataStack.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/18/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMACoreDataStack.h"

@interface SMACoreDataStack ()

@property (nonatomic, strong, readwrite) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *masterContext;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *mainContext;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *backgroundContext;


@end

@implementation SMACoreDataStack

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _masterContext = self.persistentContainer.newBackgroundContext;
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _mainContext.parentContext = _masterContext;
        _backgroundContext.parentContext = _mainContext;
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static SMACoreDataStack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SMACoreDataStack alloc] init];
    });
    return sharedInstance;
}

- (NSPersistentContainer *)persistentContainer
{
    @synchronized (self) {
        if (_persistentContainer == nil)
        {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"WeatherTravel"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil)
                {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                }
            }];
        }
    }
    
    return _persistentContainer;
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    if ([context hasChanges])
    {
        NSError *error = nil;
        if ([context save:&error])
        {
            if (context.parentContext)
            {
                [self saveContext:context.parentContext];
            }
        }
        else
        {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        }
    }
}

@end
