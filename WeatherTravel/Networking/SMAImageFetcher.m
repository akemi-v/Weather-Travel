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

@implementation SMAImageFetcher

- (void)getImageURLsWithParameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler
{
    NSURLRequest *request = [SMAFlickrImageRequest
                             getUrlRequestWithParameters:parameters];
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
                                                           
                                                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                               completionHandler(imageURLsdata);
                                                           });
                                                       }];
    
    [sessionDataTask resume];
}

@end
