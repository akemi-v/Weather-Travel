//
//  SMAFlickrImageParser.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/10/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAParserProtocol.h"


/**
 Парсер данных об изображения с Flickr
 */
@interface SMAFlickrImageParser : NSObject <SMAParserProtocol>

+ (id)parse:(NSData *)data;

@end
