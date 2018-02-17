//
//  SMADarkSkyCurrentWeatherRequest.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/8/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMARequestProtocol.h"

/**
 Реквест погодных данных Dark Sky API
 */
@interface SMADarkSkyCurrentWeatherRequest : NSObject <SMARequestProtocol>

+ (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters;

@end
