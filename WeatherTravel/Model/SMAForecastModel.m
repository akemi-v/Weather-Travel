//
//  SMAForecastModel.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/2/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAForecastModel.h"

@implementation SMAForecastModel

#pragma mark - init

- (instancetype)initWithForecastInfo:(NSDictionary *)info
{
    self = [super init];
    if (self)
    {
        self.temperature = info[@"temperature"];
        self.humidity = info[@"humidity"];
        self.summaryWeather = info[@"summary_weather"];
        self.time = info[@"time"];
        self.date = info[@"date"];
        self.city = info[@"city"];
        self.country = info[@"country"];
        self.urlOrigImage = info[@"url_orig"];
        self.urlSquareImage = info[@"url_square"];
    }
    return self;
}

@end
