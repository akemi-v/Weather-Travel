//
//  SMAWeatherFetcher.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/8/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Класс объекта, возвращающего погодные данные по географическим координатам
 */
@interface SMAWeatherFetcher : NSObject

/**
 Метод, возвращающий погодные данные по координатам

 @param coordinates Географические координаты локации
 @param completionHandler Блок, выполняемый после получения координат
 */
- (void)getWeatherFromCoordinates:(NSDictionary *)coordinates completion:(void (^)(NSDictionary *weatherData))completionHandler;

@end
