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
        _temperature = info[@"temperature"];
        _humidity = info[@"humidity"];
        _summaryWeather = info[@"summary_weather"];
        _time = info[@"time"];
        _date = info[@"date"];
        _city = info[@"city"];
        _country = info[@"country"];
        _urlOrigImage = info[@"url_orig"];
        _urlSquareImage = info[@"url_square"];
    }
    return self;
}

@end
