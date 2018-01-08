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
    
    NSString *clouds = currently[@"icon"];
    if (!clouds)
    {
        NSLog(@"Отсутствует ключ icon");
        return nil;
    }
    
    [clouds stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    
    NSDictionary *weatherData = [NSDictionary dictionaryWithObjectsAndKeys:
                                 temperature, @"temperature",
                                 humidity, @"humidity",
                                 clouds, @"clouds",
                                 nil];
    return weatherData;
}

@end
