//
//  RequestProtocol.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RequestProtocol <NSObject>

- (NSMutableURLRequest *)getUrlRequestWithParameters:(NSDictionary *)parameters;

@end