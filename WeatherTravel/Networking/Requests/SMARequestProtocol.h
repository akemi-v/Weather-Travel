//
//  SMARequestProtocol.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Протокол реквестов
 */
@protocol SMARequestProtocol <NSObject>

/**
 Получение реквеста

 @param parameters Параметры, необходимые для включения в реквест
 @return Реквест
 */
+ (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters;

@end
