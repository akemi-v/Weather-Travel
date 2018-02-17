//
//  SMAGeocoder.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Класс объекта, возвращающего по строке с названием города координаты этого города
 */
@interface SMAGeocoder : NSObject

/**
 Метод, возвращающий координаты города по названию города

 @param cityName Название города
 @param completionHandler Блок, выполняемый после получения координат
 */
- (void)getCoordinatesFromCityName:(NSString *)cityName completion:(void (^)(NSDictionary *coordinates))completionHandler;

@end
