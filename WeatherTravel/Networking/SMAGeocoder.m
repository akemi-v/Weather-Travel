//
//  SMAGeocoder.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAGeocoder.h"
#import "SMAGoogleCoordinatesRequest.h"
#import "SMAGoogleCoordinatesParser.h"

@implementation SMAGeocoder

- (void)getCoordinatesFromCityName:(NSString *)cityName completion:(void (^)(NSDictionary *coordinates))completionHandler
{
    if (!cityName)
    {
        NSLog(@"No city name");
        return;
    }
    NSURLRequest *request = [SMAGoogleCoordinatesRequest
                             getUrlRequestWithParameters:@{@"cityName": cityName}];
    if (!request)
    {
        return;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data,
                                                                           NSURLResponse * _Nullable response,
                                                                           NSError * _Nullable error) {
                                                           
                                                           if (!data || error)
                                                           {
                                                               NSLog(@"Network error: %@", error.localizedDescription);
                                                               return;
                                                           }
                                                           NSDictionary *coordinates = [SMAGoogleCoordinatesParser parse:data];
                                                           completionHandler(coordinates);
                                                       }];
    
    [sessionDataTask resume];
    [session finishTasksAndInvalidate];
}

@end
