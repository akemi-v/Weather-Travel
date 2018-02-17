//
//  SMAImageLoader.m
//  WeatherTravel
//
//  Created by Maria Semakova on 1/13/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import "SMAImageLoader.h"
#import <UIKit/UIKit.h>


@interface SMAImageLoader ()

/**
 Генератор случайной строки

 @return Случайная строка
 */
- (NSString *)randomId;

@end


@implementation SMAImageLoader

- (void)loadImageFromRemoteURL:(NSString *)urlString completion:(void (^)(UIImage *))completionHandler
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url)
    {
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (!request)
    {
        return;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                           
                                                           if (!data)
                                                           {
                                                               NSLog(@"Network error: %@", error.localizedDescription);
                                                               return;
                                                           }
                                                           UIImage *image = [UIImage imageWithData:data];
                                                           
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               completionHandler(image);
                                                           });
                                                       }];
    
    [sessionDataTask resume];
    [session finishTasksAndInvalidate];
}

- (void)loadImageFromFileURL:(NSString *)urlString completion:(void (^)(UIImage *image))completionHandler
{
    NSArray *paths = [self getPathForDirectoriesInDomains];
    NSString *documentsDirectory = paths[0];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:urlString];
    
    if (!imagePath)
    {
        NSLog(@"Нет пути к папке");
        return;
    }
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:imagePath options:0 error:&error];
    
    if (!data)
    {
        NSLog(@"Data not found, %@", error.localizedDescription);
        return;
    }
    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(image);
    });
}

- (void)saveImage:(UIImage *)image completion:(void (^)(NSString *urlString))completionHandler
{
    NSArray *paths = [self getPathForDirectoriesInDomains];
    NSString *documentsDirectory = paths[0];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [self randomId]];
    NSString *folderName = @"CityImages";
    NSString *relativePath = [folderName stringByAppendingPathComponent:imageName];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:folderName];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:relativePath];
    
    if (!fullPath)
    {
        NSLog(@"Нет пути к папке");
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath])
    {
        NSError *error = nil;
        if (![fileManager createDirectoryAtPath:folderPath
                    withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Ошибка создание директории для сохранения: %@", error.localizedDescription);
            return;
        }
    }
    
    
    NSData *data = [self representationOfImage:image];
    
    if (!data)
    {
        NSLog(@"Ошибка в генерировании данных по изображению");
        return;
    }
    
    NSError *error = nil;
    if ([data writeToFile:fullPath options:0 error:&error])
    {
        completionHandler(relativePath);
    }
    else
    {
        NSLog(@"Ошибка записи в файл: %@", error.localizedDescription);
    }
}

- (NSString *)randomId
{
    return [[NSProcessInfo processInfo] globallyUniqueString];
}

- (NSArray *)getPathForDirectoriesInDomains
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
}

- (NSData *)representationOfImage:(UIImage *)image
{
    return UIImageJPEGRepresentation(image, 1.f);
}

@end
