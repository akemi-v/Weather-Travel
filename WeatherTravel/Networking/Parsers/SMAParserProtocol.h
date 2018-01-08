//
//  SMAParserProtocol.h
//  WeatherTravel
//
//  Created by Maria Semakova on 1/7/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SMAParserProtocol <NSObject>

- (id)parse:(NSData *)data;

@end
