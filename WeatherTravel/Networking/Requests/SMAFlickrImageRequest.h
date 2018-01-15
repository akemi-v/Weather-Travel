//
//  SMAFlickrImageRequest.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/9/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMARequestProtocol.h"


/**
 Реквест фотографий Flickr API
 */
@interface SMAFlickrImageRequest : NSObject <SMARequestProtocol>

+ (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters;

@end
