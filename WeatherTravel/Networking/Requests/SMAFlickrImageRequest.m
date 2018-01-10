//
//  SMAFlickrImageFetcher.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/9/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAFlickrImageRequest.h"
#import "Enums.h"

@interface SMAFlickrImageRequest ()

/**
 Реквест для поиска фото по локации и погоде в группе Project Weather https://www.flickr.com/groups/1463451@N25/

 @param parameters Параметры для построения реквеста (локация, погода)
 @param urlComponents Общие (для всех реквестов) компоненты
 @return Реквест
 */
+ (NSMutableURLRequest *)getUrlRequestPlaceWeatherGroupWithParameters:(NSDictionary *)parameters withURLComponents:(NSURLComponents *)urlComponents;

/**
 Реквест для поиска фото по локации и погоде (не в группе)

 @param parameters Параметры для построения реквеста (локация, погода)
 @param urlComponents Общие (для всех реквестов) компоненты
 @return Реквест
 */
+ (NSMutableURLRequest *)getUrlRequestPlaceWeatherWithParameters:(NSDictionary *)parameters withURLComponents:(NSURLComponents *)urlComponents;

/**
 Реквест для поиска фото по локации (не в группе)

 @param parameters Параметры для построения реквеста (локация)
 @param urlComponents Общие (для всех реквестов) компоненты
 @return Реквест
 */
+ (NSMutableURLRequest *)getUrlRequestPlaceWithParameters:(NSDictionary *)parameters withURLComponents:(NSURLComponents *)urlComponents;

@end

@implementation SMAFlickrImageRequest

+ (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters
{
    Mode mode = [parameters[@"mode"] intValue];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://api.flickr.com/services/rest/"];
    NSURLQueryItem *method = [NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.search"];
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:@"api_key" value:@"893bb425c9623527bf0b2447a5878d19"];
    NSURLQueryItem *tagMode = [NSURLQueryItem queryItemWithName:@"tag_mode" value:@"all"];
    NSURLQueryItem *perPage = [NSURLQueryItem queryItemWithName:@"per_page" value:[NSString stringWithFormat:@"%d", 100]];
    NSURLQueryItem *format = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
    NSURLQueryItem *imgFormat = [NSURLQueryItem queryItemWithName:@"extras" value:@"url_q,url_o"];
    NSURLQueryItem *noCallBack = [NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"];
    urlComponents.queryItems = @[method, apiKey, tagMode, perPage, format, imgFormat, noCallBack];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    switch (mode) {
        case PlaceWeatherGroup:
            request = [self getUrlRequestPlaceWeatherGroupWithParameters:parameters
                                                       withURLComponents:urlComponents];
            break;
            
        case PlaceWeather:
            request = [self getUrlRequestPlaceWeatherWithParameters:parameters
                                                  withURLComponents:urlComponents];
            break;
        case Place:
            request = [self getUrlRequestPlaceWithParameters:parameters
                                           withURLComponents:urlComponents];
            break;
        default:
            return nil;
    }
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    return request;
}

+ (NSMutableURLRequest *)getUrlRequestPlaceWeatherGroupWithParameters:(NSDictionary *)parameters
                                                    withURLComponents:(NSURLComponents *)urlComponents
{
    NSString *projectWeatherGroupId = @"1463451@N25"; // Project Weather group ID
    NSString *weatherString = parameters[@"weather"];
    NSString *cityString = parameters[@"city"];
    NSArray *tagsArray = @[weatherString, cityString];
    NSString *tagsString = [tagsArray componentsJoinedByString:@","];
    
    NSURLQueryItem *tags = [NSURLQueryItem queryItemWithName:@"tags" value:tagsString];
    NSURLQueryItem *group = [NSURLQueryItem queryItemWithName:@"group_id" value:projectWeatherGroupId];
    urlComponents.queryItems = [urlComponents.queryItems arrayByAddingObjectsFromArray:@[tags, group]];
    NSURL *url = urlComponents.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    return request;
}

+ (NSMutableURLRequest *)getUrlRequestPlaceWeatherWithParameters:(NSDictionary *)parameters
                                               withURLComponents:(NSURLComponents *)urlComponents
{
    NSString *weatherString = parameters[@"weather"];
    NSString *cityString = parameters[@"city"];
    NSArray *tagsArray = @[weatherString, cityString];
    NSString *tagsString = [tagsArray componentsJoinedByString:@","];
    
    NSURLQueryItem *tags = [NSURLQueryItem queryItemWithName:@"tags" value:tagsString];
    urlComponents.queryItems = [urlComponents.queryItems arrayByAddingObject:tags];
    NSURL *url = urlComponents.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    return request;
}

+ (NSMutableURLRequest *)getUrlRequestPlaceWithParameters:(NSDictionary *)parameters
                                        withURLComponents:(NSURLComponents *)urlComponents
{
    NSString *cityString = parameters[@"city"];
    NSArray *tagsArray = @[cityString];
    NSString *tagsString = [tagsArray componentsJoinedByString:@","];

    NSURLQueryItem *tags = [NSURLQueryItem queryItemWithName:@"tags" value:tagsString];
    urlComponents.queryItems = [urlComponents.queryItems arrayByAddingObject:tags];
    NSURL *url = urlComponents.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    return request;
}

@end
