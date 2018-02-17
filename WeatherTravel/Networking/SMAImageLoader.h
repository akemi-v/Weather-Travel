//
//  SMAImageLoader.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/13/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 Класс объекта, загружающего изображение
 */
@interface SMAImageLoader : NSObject

/**
 Загрузить изображение по URL из сети

 @param urlString URL-адрес изображения в сети
 @param completionHandler Блок, выполняемый после загрузки изображения
 */
- (void)loadImageFromRemoteURL:(NSString *)urlString completion:(void (^)(UIImage *image))completionHandler;

/**
 Загрузить изображение по URL из локального хранилища файлов

 @param urlString URL-адрес локального изображения
 @param completionHandler Блок, выполняемый после загрузки изображения
 */
- (void)loadImageFromFileURL:(NSString *)urlString completion:(void (^)(UIImage *image))completionHandler;

/**
 Сохранить изображение в локальном хранилище

 @param image Изображение для сохранения
 @param completionHandler Блок, выполняемый после сохранения изображения
 */
- (void)saveImage:(UIImage *)image completion:(void (^)(NSString *urlString))completionHandler;
@end
