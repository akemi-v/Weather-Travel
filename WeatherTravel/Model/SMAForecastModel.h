//
//  SMAForecastModel.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/2/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Модель, хранящая информацию о прогнозе
 */
@interface SMAForecastModel : NSObject

@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *summaryWeather;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *urlOrigImage;
@property (nonatomic, strong) NSString *urlSquareImage;

/**
 Инициализация модели

 @param info Данные модели
 @return Объект модели
 */
- (instancetype)initWithForecastInfo:(NSDictionary *)info;

@end
