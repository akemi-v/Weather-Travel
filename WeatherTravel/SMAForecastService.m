//
//  SMAForecastService.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/15/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAForecastService.h"
#import "SMAForecastModel.h"


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

- (void)getForecastForCity:(NSString *)cityName completion:(void (^)(SMAForecastModel *model))completionHandler
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
                [self.imageLoader loadImageFromRemoteURL:imageURLs[@"url_orig"] completion:^(UIImage *image) {
                    [forecastInfo setObject:image forKey:@"image"];
                    
                    SMAForecastModel *model = [[SMAForecastModel alloc] initWithForecastInfo:forecastInfo];
                    completionHandler(model);
                }];
            }];
        }];
    }];

    
}

@end
