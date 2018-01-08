//
//  SMAGoogleCoordinatesParser.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAParserProtocol.h"

/**
 Парсер географических координат Google Maps API
 */
@interface SMAGoogleCoordinatesParser : NSObject <SMAParserProtocol>

+ (id)parse:(NSData *)data;

@end
