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
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
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
}

- (void)loadImageFromFileURL:(NSString *)urlString completion:(void (^)(UIImage *image))completionHandler
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectiry = paths[0];
    NSString *imagesFolderPath = [documentsDirectiry stringByAppendingPathComponent:@"CityImages"];
    NSString *imagePath = [imagesFolderPath stringByAppendingPathComponent:urlString];
    
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [self randomId]];
    NSString *folderName = @"CityImages";
    NSString *relativePath = [folderName stringByAppendingPathComponent:imageName];
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:folderName];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:relativePath];
    
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
    
    
    NSData *data = UIImageJPEGRepresentation(image, 1.f);
    NSError *error = nil;
    if ([data writeToFile:fullPath options:0 error:&error])
    {
        completionHandler(fullPath);
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

@end
