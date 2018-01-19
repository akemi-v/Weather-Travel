//
//  SMAImageFetcher.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/10/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAImageFetcher.h"
#import "SMAFlickrImageRequest.h"
#import "SMAFlickrImageParser.h"
#import "Enums.h"


@interface SMAImageFetcher ()

/**
 Получение ссылок на изображение из группы Project Weather

 @param parameters Параметры для построения реквеста (локация, погода)
 @param completionHandler Блок, выполняемый после получения ссылок
 */
- (void)getImageWithPlaceWeatherGroupRequest:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler;

/**
 Получение ссылок на изображение вне группы
 
 @param parameters Параметры для построения реквеста (локация, погода)
 @param completionHandler Блок, выполняемый после получения ссылок
 */
- (void)getImageWithPlaceWeatherRequest:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler;

/**
 Получение ссылок на изображение без погодных данных
 
 @param parameters Параметры для построения реквеста (локация)
 @param completionHandler Блок, выполняемый после получения ссылок
 */
- (void)getImageWithPlaceRequest:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler;

@end

@implementation SMAImageFetcher

- (void)getImageURLsWithParameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler
{
    [self getImageWithPlaceWeatherGroupRequest:parameters completion:completionHandler];
}

- (void)getImageWithPlaceWeatherGroupRequest:(NSDictionary *)parameters
                                  completion:(void (^)(NSDictionary *imageURLs))completionHandler
{
    NSURLRequest *request = [SMAFlickrImageRequest
                             getUrlRequestWithParameters:parameters];
    if (!request)
    {
        return;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                           
                                                           if (!data)
                                                           {
                                                               NSLog(@"Network error: %@", error.localizedDescription);
                                                               return;
                                                           }
                                                           NSDictionary *imageURLsdata = [SMAFlickrImageParser parse:data];
                                                           
                                                           if (!imageURLsdata)
                                                           {
                                                               NSLog(@"Недостаточное число фотографий. Создается запрос для поиска вне группы");
                                                               NSMutableDictionary *newParameters = [parameters mutableCopy];
                                                               NSString *modeString = [NSString stringWithFormat:@"%d", PlaceWeather];
                                                               [newParameters setObject:modeString forKey:@"mode"];
                                                               [self getImageWithPlaceWeatherRequest:newParameters completion:completionHandler];
                                                               return;
                                                           }
                                                           
                                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                                               completionHandler(imageURLsdata);
                                                           });
                                                       }];
    
    [sessionDataTask resume];
}

- (void)getImageWithPlaceWeatherRequest:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler
{
    NSURLRequest *request = [SMAFlickrImageRequest
                             getUrlRequestWithParameters:parameters];
    if (!request)
    {
        return;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                           
                                                           if (!data)
                                                           {
                                                               NSLog(@"Network error: %@", error.localizedDescription);
                                                               return;
                                                           }
                                                           NSDictionary *imageURLsdata = [SMAFlickrImageParser parse:data];
                                                           
                                                           if (!imageURLsdata)
                                                           {
                                                               NSLog(@"Недостаточное число фотографий. Создается запрос для поиска без погоды");
                                                               NSMutableDictionary *newParameters = [parameters mutableCopy];
                                                               NSString *modeString = [NSString stringWithFormat:@"%d", Place];
                                                               [newParameters setObject:modeString forKey:@"mode"];
                                                               [self getImageWithPlaceRequest:newParameters completion:completionHandler];
                                                               return;
                                                           }
                                                           
                                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                                               completionHandler(imageURLsdata);
                                                           });
                                                       }];
    
    [sessionDataTask resume];
}

- (void)getImageWithPlaceRequest:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler
{
    NSURLRequest *request = [SMAFlickrImageRequest
                             getUrlRequestWithParameters:parameters];
    if (!request)
    {
        return;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                           
                                                           if (!data)
                                                           {
                                                               NSLog(@"Network error: %@", error.localizedDescription);
                                                               return;
                                                           }
                                                           NSDictionary *imageURLsdata = [SMAFlickrImageParser parse:data];
                                                           
                                                           if (!imageURLsdata)
                                                           {
                                                               NSLog(@"Нет изображений");
                                                               return;
                                                           }
                                                           
                                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                                               completionHandler(imageURLsdata);
                                                           });
                                                       }];
    
    [sessionDataTask resume];
}


@end
