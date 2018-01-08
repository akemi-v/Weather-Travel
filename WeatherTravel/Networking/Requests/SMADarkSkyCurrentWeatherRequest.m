//
//  SMADarkSkyCurrentWeatherRequest.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/8/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMADarkSkyCurrentWeatherRequest.h"

@implementation SMADarkSkyCurrentWeatherRequest

+ (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters
{
    NSString *apiKey = @"7bb791f34616527998a0737f6b80b8e6";
    NSString *latitude = parameters[@"lat"];
    NSString *longitude = parameters[@"lng"];
    NSString *baseUrlString = [NSString
                               stringWithFormat:@"https://api.darksky.net/forecast/%@/%@,%@",
                               apiKey, latitude, longitude];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:baseUrlString];
    NSURLQueryItem *exclude = [NSURLQueryItem
                               queryItemWithName:@"exclude" value:@"minutely,hourly,daily"];
    NSURLQueryItem *units = [NSURLQueryItem queryItemWithName:@"units" value:@"si"];
    urlComponents.queryItems = @[exclude, units];
    NSURL *url = urlComponents.URL;
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    return request;
}

@end
