//
//  SMADarkSkyCurrentWeatherParser.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/8/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAParserProtocol.h"


/**
 JSON парсер погодных данных
 */
@interface SMADarkSkyCurrentWeatherParser : NSObject <SMAParserProtocol>

/**
 Метод парсинга данных

 @param data Данные о погоде в формате JSON
 @return Модель данных погоды
 */
+ (id)parse:(NSData *)data;

@end
