//
//  SMAFlickrImageParser.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/10/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAFlickrImageParser.h"

// Минимальное число возвращаемых фотографий для того
// Если число меньше, то создается реквест с другими параметрами)
static const NSUInteger SMAPhotosThreshold = 5;


@implementation SMAFlickrImageParser

+ (id)parse:(NSData *)data
{
    NSError *jsonError = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    
    if (!result)
    {
        NSLog(@"Ошибка парсинга");
        return nil;
    }
    
    NSString *status = result[@"stat"];
    if (![status isEqualToString:@"ok"])
    {
        NSLog(@"Ошибка геокодирования");
        return nil;
    }

    NSDictionary *photos = result[@"photos"];
    if (!photos)
    {
        NSLog(@"Отсутствует ключ photos");
        return nil;
    }
    
    NSString *numOfPhotos = photos[@"total"];
    if (!numOfPhotos)
    {
        NSLog(@"Отсутствует ключ total");
        return nil;
    }
    
    if ([numOfPhotos intValue] < SMAPhotosThreshold)
    {
        return nil;
    }
    
    NSArray *photoArray = photos[@"photo"];
    if (!photoArray)
    {
        NSLog(@"Отсутствует ключ photo");
        return nil;
    }
    
    for (id photo in photoArray)
    {
        if (photo[@"url_q"] && photo[@"url_o"])
        {
            NSDictionary *photoInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                       photo[@"url_q"], @"url_square",
                                       photo[@"url_o"], @"url_orig",
                                       nil];
            return photoInfo;
        }
    }
    return nil;
}

@end
