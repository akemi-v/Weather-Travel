//
//  SMACoreDataService.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/18/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SMACoreDataStack.h"
#import "SMAForecastModel.h"
#import "Forecast+CoreDataProperties.h"

@interface SMACoreDataService : NSObject

+ (void)insertForecast:(SMAForecastModel *)forecastModel inContext:(NSManagedObjectContext *)context;
+ (NSArray <Forecast *> *)fetchHistoryForecastsInContext:(NSManagedObjectContext *)context;

@end
