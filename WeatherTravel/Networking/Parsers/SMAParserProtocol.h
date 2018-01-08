//
//  SMAParserProtocol.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Протокол JSON парсера
 */
@protocol SMAParserProtocol <NSObject>

/**
 Парсинг
 
 @param data Данные для парсинга
 @return Модель данных, полученная в результате парсинга
 */
+ (id)parse:(NSData *)data;

@end
