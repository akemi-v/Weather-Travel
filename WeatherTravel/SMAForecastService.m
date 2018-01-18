//
//  SMAForecastService.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/15/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAForecastService.h"
#import "SMAForecastModel.h"
#import "SMACoreDataService.h"


@interface SMAForecastService ()

@property (nonatomic, strong) SMAImageLoader *imageLoader;
@property (nonatomic, strong) SMAImageFetcher *imageFetcher;
@property (nonatomic, strong) SMAGeocoder *geocoder;
@property (nonatomic, strong) SMAWeatherFetcher *weatherFetcher;

@end

@implementation SMAForecastService

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.imageLoader = [SMAImageLoader new];
        self.imageFetcher = [SMAImageFetcher new];
        self.geocoder = [SMAGeocoder new];
        self.weatherFetcher = [SMAWeatherFetcher new];
    }
    return self;
}

- (void)getForecastForCityOnline:(NSString *)cityName completion:(void (^)(SMAForecastModel *model))completionHandler
{
    __block NSMutableDictionary *forecastInfo = [NSMutableDictionary new];
    [self.geocoder getCoordinatesFromCityName:cityName completion:^(NSDictionary *coordinates) {
        if (!coordinates)
        {
            return;
        }
        [self.weatherFetcher getWeatherFromCoordinates:coordinates completion:^(NSDictionary *weatherData) {
            if (!weatherData)
            {
                return;
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSDate *currentDate = [NSDate date];
            NSString *timeString = [formatter stringFromDate:currentDate];
            
            [formatter setDateFormat:@"dd-MM-yyyy"];
            NSString *dateString = [formatter stringFromDate:currentDate];
            [forecastInfo setObject:[NSString stringWithFormat:@"%@", weatherData[@"temperature"]] forKey:@"temperature"];
            [forecastInfo setObject:[NSString stringWithFormat:@"%@", weatherData[@"humidity"]] forKey:@"humidity"];
            [forecastInfo setObject:weatherData[@"summary_weather"] forKey:@"summary_weather"];
            [forecastInfo setObject:timeString forKey:@"time"];
            [forecastInfo setObject:dateString forKey:@"date"];
            [forecastInfo setObject:coordinates[@"city"] forKey:@"city"];
            [forecastInfo setObject:coordinates[@"country"] forKey:@"country"];
            NSMutableDictionary *parameters = [weatherData mutableCopy];
            [parameters setObject:coordinates[@"city"] forKey:@"city"];
            [self.imageFetcher getImageURLsWithParameters:parameters completion:^(NSDictionary *imageURLs) {
                [forecastInfo setObject:imageURLs[@"url_orig"] forKey:@"url_orig"];
                [forecastInfo setObject:imageURLs[@"url_square"] forKey:@"url_square"];
                
                SMAForecastModel *model = [[SMAForecastModel alloc] initWithForecastInfo:forecastInfo];
                completionHandler(model);
            }];
        }];
    }];
}

- (void)getForecastsHistoryCompletion:(void (^)(NSArray <SMAForecastModel *> *models))completionHandler
{
    NSArray <Forecast *> *forecasts = [SMACoreDataService fetchHistoryForecasts];
    if (!forecasts)
    {
        NSLog(@"Нет данных в истории");
        return;
    }
    NSMutableArray <SMAForecastModel *> *models = [NSMutableArray new];
    for (id forecast in forecasts)
    {
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [forecast valueForKey:@"temperature"], @"temperature",
                                    [forecast valueForKey:@"humidity"], @"humidity",
                                    [forecast valueForKey:@"summaryWeather"], @"summary_weather",
                                    [forecast valueForKey:@"time"], @"time",
                                    [forecast valueForKey:@"date"], @"date",
                                    [forecast valueForKey:@"city"], @"city",
                                    [forecast valueForKey:@"country"], @"country",
                                    [forecast valueForKey:@"urlOrig"], @"url_orig",
                                    [forecast valueForKey:@"urlSquare"], @"url_square",
                                    nil];
        SMAForecastModel *model = [[SMAForecastModel alloc] initWithForecastInfo:parameters];
        [models addObject:model];
    }
    completionHandler(models);
}

@end
