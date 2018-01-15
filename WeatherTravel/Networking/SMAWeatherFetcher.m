//
//  SMAWeatherFetcher.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/8/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAWeatherFetcher.h"
#import "SMADarkSkyCurrentWeatherRequest.h"
#import "SMADarkSkyCurrentWeatherParser.h"


@implementation SMAWeatherFetcher

- (void)getWeatherFromCoordinates:(NSDictionary *)coordinates completion:(void (^)(NSDictionary *weatherData))completionHandler
{
    NSURLRequest *request = [SMADarkSkyCurrentWeatherRequest
                             getUrlRequestWithParameters:coordinates];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data)
        {
            NSLog(@"Network error: %@", error.localizedDescription);
            return;
        }
        NSDictionary *weatherData = [SMADarkSkyCurrentWeatherParser parse:data];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            completionHandler(weatherData);
        });
    }];
    
    [sessionDataTask resume];
}


@end
