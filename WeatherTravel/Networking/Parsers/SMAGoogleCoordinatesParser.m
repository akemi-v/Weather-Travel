//
//  SMAGoogleCoordinatesParser.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAGoogleCoordinatesParser.h"

@implementation SMAGoogleCoordinatesParser

+ (id)parse:(NSData *)data
{
    NSError *jsonError = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if (!result)
    {
        NSLog(@"Ошибка парсинга");
        return nil;
    }
    
    NSString *status = result[@"status"];
    if (![status isEqualToString:@"OK"])
    {
        NSLog(@"Ошибка геокодирования");
        return nil;
    }
    
    NSArray *results = result[@"results"];
    if (!results)
    {
        NSLog(@"Отсутствует ключ results");
        return nil;
    }
    
    NSDictionary *geometry = [results firstObject][@"geometry"];
    if (!geometry)
    {
        NSLog(@"Отсутствует ключ geometry");
        return nil;
    }
    
    NSDictionary *locationCoordinates = geometry[@"location"];
    if (!locationCoordinates)
    {
        NSLog(@"Отсутствует ключ location");
        return nil;
    }
    
    NSArray *addressComponents = [results firstObject][@"address_components"];
    if (!addressComponents)
    {
        NSLog(@"Отсутствует ключ address_components");
        return nil;
    }
    
    NSString *city = [addressComponents firstObject][@"short_name"];
    if (!city)
    {
        NSLog(@"Отсутствует ключ short_name");
        return nil;
    }
    
    NSString *country = [addressComponents lastObject][@"long_name"];
    if (!country)
    {
        NSLog(@"Отсутствует ключ long_name");
        return nil;
    }
    
    NSMutableDictionary *location = [locationCoordinates mutableCopy];
    [location setObject:city forKey:@"city"];
    [location setObject:country forKey:@"country"];
    
    return location;
}

@end
