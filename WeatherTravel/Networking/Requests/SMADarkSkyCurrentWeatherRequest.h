//
//  SMADarkSkyCurrentWeatherRequest.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/8/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMARequestProtocol.h"


@interface SMADarkSkyCurrentWeatherRequest : NSObject

+ (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters;

@end
