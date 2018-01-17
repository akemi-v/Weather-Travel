//
//  Forecast+CoreDataProperties.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/18/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//
//

#import "Forecast+CoreDataProperties.h"

@implementation Forecast (CoreDataProperties)

+ (NSFetchRequest<Forecast *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Forecast"];
}

@dynamic id;
@dynamic temperature;
@dynamic humidity;
@dynamic summaryWeather;
@dynamic time;
@dynamic date;
@dynamic city;
@dynamic country;
@dynamic urlOrig;
@dynamic urlSquare;

@end
