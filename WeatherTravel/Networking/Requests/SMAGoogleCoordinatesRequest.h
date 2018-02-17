//
//  SMAGoogleCoordinatesRequest.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMARequestProtocol.h"

/**
 Реквест географических координат Google Maps API
 */
@interface SMAGoogleCoordinatesRequest : NSObject <SMARequestProtocol>

+ (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters;

@end
