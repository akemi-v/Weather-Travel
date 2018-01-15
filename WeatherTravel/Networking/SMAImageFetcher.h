//
//  SMAImageFetcher.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/10/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Класс объекта, возвращающего ссылки на изображения с Flickr
 */
@interface SMAImageFetcher : NSObject

/**
 Метод, возвращающий ссылки на изображение по параметрам (локация, погода)

 @param parameters Параметры (локация, погода)
 @param completionHandler Блок, выполняемый после получения координат 
 */
- (void)getImageURLsWithParameters:(NSDictionary *)parameters completion:(void (^)(NSDictionary *imageURLs))completionHandler;

@end
