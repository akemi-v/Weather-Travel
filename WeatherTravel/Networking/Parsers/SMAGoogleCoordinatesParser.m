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
    if (!results)
    {
        NSLog(@"Отсутствует ключ geometry");
        return nil;
    }
    
    NSDictionary *location = geometry[@"location"];
    if (!location)
    {
        NSLog(@"Отсутствует ключ location");
        return nil;
    }
    return location;
}

@end
