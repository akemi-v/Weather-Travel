//
//  SMACoreDataStack.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/18/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SMACoreDataStack : NSObject

@property (nonatomic, strong, readonly) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong, readonly) NSManagedObjectContext *masterContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;

+ (instancetype)sharedInstance;
- (void)saveContext:(NSManagedObjectContext *)context;

@end
