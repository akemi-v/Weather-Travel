//
//  SMAGeocoderTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "SMAGeocoder.h"
#import "SMAGoogleCoordinatesParser.h"

@interface SMAGeocoder(Tests)

- (void)getCoordinatesFromCityName:(NSString *)cityName completion:(void (^)(NSDictionary *coordinates))completionHandler;

@end

@interface SMAGeocoderTests : XCTestCase

@property (nonatomic, strong) SMAGeocoder *geocoder;

@end

@implementation SMAGeocoderTests

- (void)setUp
{
    [super setUp];
    self.geocoder = OCMPartialMock([SMAGeocoder new]);
}

- (void)tearDown
{
    self.geocoder = nil;
    [super tearDown];
}

- (void)testGetCoordinatesFromCityNameEmpty
{
    NSString *cityName = @"";
    
    __block BOOL isCalled = NO;
    [self.geocoder getCoordinatesFromCityName:cityName completion:^(NSDictionary *coordinates) {
        isCalled = YES;
    }];
    expect(isCalled).after(2).to.beFalsy();
}

- (void)testGetCoordinatesFromCityNameNoise
{
    NSString *cityName = @"dsfhjksdhfjkahfjkhdjkfhajhfdjshdajksdh";
    
    __block BOOL isCalled = NO;
    [self.geocoder getCoordinatesFromCityName:cityName completion:^(NSDictionary *coordinates) {
        isCalled = YES;
    }];
     expect(isCalled).after(2).to.beFalsy();
}

- (void)testGetCoordinatesFromCityNameReal
{
    NSString *cityName = @"Лондон";
    
    __block BOOL isCalled = NO;
    __block NSDictionary *coords = nil;
    [self.geocoder getCoordinatesFromCityName:cityName completion:^(NSDictionary *coordinates) {
        isCalled = YES;
        coords = coordinates;
    }];
    expect(isCalled).after(2).to.beTruthy();
    expect(coords).toNot.beNil();
}

@end
