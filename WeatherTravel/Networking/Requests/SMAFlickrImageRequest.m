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

+ (NSMutableURLRequest *)getUrlRequestPlaceWeatherGroupWithParameters:(NSDictionary *)parameters;
+ (NSMutableURLRequest *)getUrlRequestPlaceWeatherWithParameters:(NSDictionary *)parameters;
+ (NSMutableURLRequest *)getUrlRequestPlaceWithParameters:(NSDictionary *)parameters;

@end

@implementation SMAFlickrImageRequest

+ (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters
{
    Mode mode = [parameters[@"mode"] intValue];
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    switch (mode) {
        case PlaceWeatherGroup:
            request = [self getUrlRequestPlaceWeatherGroupWithParameters:parameters];
            break;
            
        case PlaceWeather:
            request = [self getUrlRequestPlaceWeatherWithParameters:parameters];
            break;
        case Place:
            request = [self getUrlRequestPlaceWithParameters:parameters];
            break;
        default:
            return nil;
    }
    
    return request;
}

+ (NSMutableURLRequest *)getUrlRequestPlaceWeatherGroupWithParameters:(NSDictionary *)parameters
{
    NSString *projectWeatherGroupId = @"1463451@N25";
    NSString *weatherString = parameters[@"weather"];
    NSString *cityString = parameters[@"city"];
    NSArray *tagsArray = @[weatherString, cityString];
    NSString *tagsString = [tagsArray componentsJoinedByString:@","];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://api.flickr.com/services/rest/"];
    NSURLQueryItem *method = [NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.search"];
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:@"api_key" value:@"893bb425c9623527bf0b2447a5878d19"];
    NSURLQueryItem *tags = [NSURLQueryItem queryItemWithName:@"tags" value:tagsString];
    NSURLQueryItem *tagMode = [NSURLQueryItem queryItemWithName:@"tag_mode" value:@"all"];
    NSURLQueryItem *group = [NSURLQueryItem queryItemWithName:@"group_id" value:projectWeatherGroupId];
    NSURLQueryItem *perPage = [NSURLQueryItem queryItemWithName:@"per_page" value:[NSString stringWithFormat:@"%d", 100]];
    NSURLQueryItem *format = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
    NSURLQueryItem *imgFormat = [NSURLQueryItem queryItemWithName:@"extras" value:@"url_q,url_o"];
    NSURLQueryItem *noCallBack = [NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"];
    urlComponents.queryItems = @[method, apiKey, tags, tagMode, group, perPage, format, imgFormat, noCallBack];
    NSURL *url = urlComponents.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    return request;
}

+ (NSMutableURLRequest *)getUrlRequestPlaceWeatherWithParameters:(NSDictionary *)parameters
{
    NSString *weatherString = parameters[@"weather"];
    NSString *cityString = parameters[@"city"];
    NSArray *tagsArray = @[weatherString, cityString];
    NSString *tagsString = [tagsArray componentsJoinedByString:@","];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://api.flickr.com/services/rest/"];
    NSURLQueryItem *method = [NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.search"];
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:@"api_key" value:@"893bb425c9623527bf0b2447a5878d19"];
    NSURLQueryItem *tags = [NSURLQueryItem queryItemWithName:@"tags" value:tagsString];
    NSURLQueryItem *tagMode = [NSURLQueryItem queryItemWithName:@"tag_mode" value:@"all"];
    NSURLQueryItem *perPage = [NSURLQueryItem queryItemWithName:@"per_page" value:[NSString stringWithFormat:@"%d", 100]];
    NSURLQueryItem *format = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
    NSURLQueryItem *imgFormat = [NSURLQueryItem queryItemWithName:@"extras" value:@"url_q,url_o"];
    NSURLQueryItem *noCallBack = [NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"];
    urlComponents.queryItems = @[method, apiKey, tags, tagMode, perPage, format, imgFormat, noCallBack];
    NSURL *url = urlComponents.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    return request;
}

+ (NSMutableURLRequest *)getUrlRequestPlaceWithParameters:(NSDictionary *)parameters
{
    NSString *cityString = parameters[@"city"];
    NSArray *tagsArray = @[cityString];
    NSString *tagsString = [tagsArray componentsJoinedByString:@","];
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://api.flickr.com/services/rest/"];
    NSURLQueryItem *method = [NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.search"];
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:@"api_key" value:@"893bb425c9623527bf0b2447a5878d19"];
    NSURLQueryItem *tags = [NSURLQueryItem queryItemWithName:@"tags" value:tagsString];
    NSURLQueryItem *tagMode = [NSURLQueryItem queryItemWithName:@"tag_mode" value:@"all"];
    NSURLQueryItem *perPage = [NSURLQueryItem queryItemWithName:@"per_page" value:[NSString stringWithFormat:@"%d", 100]];
    NSURLQueryItem *format = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
    NSURLQueryItem *imgFormat = [NSURLQueryItem queryItemWithName:@"extras" value:@"url_q,url_o"];
    NSURLQueryItem *noCallBack = [NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"];
    urlComponents.queryItems = @[method, apiKey, tags, tagMode, perPage, format, imgFormat, noCallBack];
    NSURL *url = urlComponents.URL;
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    return request;
}

@end
