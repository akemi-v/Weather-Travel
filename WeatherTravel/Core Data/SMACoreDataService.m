//
//  SMACoreDataService.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/18/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMACoreDataService.h"

@implementation SMACoreDataService

+ (void)insertForecast:(SMAForecastModel *)forecastModel
{
    SMACoreDataStack *stack = [SMACoreDataStack sharedInstance];
    NSManagedObjectContext *context = stack.masterContext;
    Forecast *forecast = [[Forecast alloc] initWithContext:context];
    forecast.idString = [self randomId];
    forecast.temperature = forecastModel.temperature;
    forecast.humidity = forecastModel.humidity;
    forecast.summaryWeather = forecastModel.summaryWeather;
    forecast.time = forecastModel.time;
    forecast.date = forecastModel.date;
    forecast.city = forecastModel.city;
    forecast.country = forecastModel.country;
    forecast.urlOrig = forecastModel.urlOrigImage;
    forecast.urlSquare = forecastModel.urlSquareImage;
    
    [context performBlock:^{
        [stack saveContext:context];
    }];
}

+ (NSArray <Forecast *> *)fetchHistoryForecasts
{
    SMACoreDataStack *stack = [SMACoreDataStack sharedInstance];
    NSManagedObjectContext *context = stack.backgroundContext;
    __block NSArray<Forecast *> *forecasts = nil;
    [context performBlockAndWait:^{
        NSFetchRequest *fetchRequest = [Forecast fetchRequest];
        NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        NSSortDescriptor *timeSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
        fetchRequest.sortDescriptors = @[dateSortDescriptor, timeSortDescriptor];
        
        NSError *error = nil;
        forecasts = [context executeFetchRequest:fetchRequest error:&error];
        if (!forecasts)
        {
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        }
    }];
    
    return forecasts;
}

+ (NSString *)randomId
{
    return [[NSProcessInfo processInfo] globallyUniqueString];
}

@end
