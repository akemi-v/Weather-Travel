//
//  SMADarkSkyCurrentWeatherParser.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/8/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMADarkSkyCurrentWeatherParser.h"

@implementation SMADarkSkyCurrentWeatherParser

+ (id)parse:(NSData *)data
{
    NSError *jsonError = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if (!result)
    {
        NSLog(@"Ошибка парсинга");
        return nil;
    }
    
    NSDictionary *currently = result[@"currently"];
    if (!currently)
    {
        NSLog(@"Отсутствует ключ currently");
        return nil;
    }
    
    NSString *temperature = currently[@"temperature"];
    if (!temperature)
    {
        NSLog(@"Отсутствует ключ temperature");
        return nil;
    }
    
    NSString *humidity = currently[@"humidity"];
    if (!humidity)
    {
        NSLog(@"Отсутствует ключ humidity");
        return nil;
    }
    
    NSString *summaryWeather = currently[@"icon"];
    if (!summaryWeather)
    {
        NSLog(@"Отсутствует ключ icon");
        return nil;
    }
    
    summaryWeather = [summaryWeather stringByReplacingOccurrencesOfString:@"-" withString:@","];
    
    NSDictionary *weatherData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 temperature, @"temperature",
                                 humidity, @"humidity",
                                 summaryWeather, @"summary_weather",
                                 nil];
    return weatherData;
}

@end
