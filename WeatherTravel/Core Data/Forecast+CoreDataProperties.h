//
//  Forecast+CoreDataProperties.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/18/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//
//

#import "Forecast+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Forecast (CoreDataProperties)

+ (NSFetchRequest<Forecast *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *temperature;
@property (nullable, nonatomic, copy) NSString *humidity;
@property (nullable, nonatomic, copy) NSString *summaryWeather;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *city;
@property (nullable, nonatomic, copy) NSString *country;
@property (nullable, nonatomic, copy) NSString *urlOrig;
@property (nullable, nonatomic, copy) NSString *urlSquare;

@end

NS_ASSUME_NONNULL_END
