//
//  SMAGoogleCoordinatesRequest.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAGoogleCoordinatesRequest.h"

@implementation SMAGoogleCoordinatesRequest

+ (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"https://maps.googleapis.com/maps/api/geocode/json?"];
    NSURLQueryItem *apiKey = [NSURLQueryItem queryItemWithName:@"key" value:@"AIzaSyALIwcUWsF8qd2gY-Aa4Saa-v-LL8edXFg"];
    NSURLQueryItem *city = [NSURLQueryItem queryItemWithName:@"address" value:parameters[@"cityName"]];
    urlComponents.queryItems = @[apiKey, city];
    NSURL *url = urlComponents.URL;
    
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    return request;
}

@end
