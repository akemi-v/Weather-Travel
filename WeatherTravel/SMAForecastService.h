//
//  SMAForecastService.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/15/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAImageLoader.h"
#import "SMAImageFetcher.h"
#import "SMAGeocoder.h"
#import "SMAWeatherFetcher.h"
#import "SMAForecastModel.h"


/**
 Сервис, составляющий SMAForecastModel
 */
@interface SMAForecastService : NSObject

/**
 Метод, возвращающий SMAForecastModel для города

 @param cityName Название города
 @param completionHandler Блок, выполняемый после получения названия города
 */
- (void)getForecastForCityOnline:(NSString *)cityName completion:(void (^)(SMAForecastModel *model))completionHandler;

/**
 Метод, возвращающий историю прогнозов

 @param completionHandler Блок, выполняемый после получения истории
 */
- (void)getForecastsHistoryCompletion:(void (^)(NSArray <SMAForecastModel *> *models))completionHandler;
@end
