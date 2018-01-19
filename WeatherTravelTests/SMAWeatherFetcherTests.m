//
//  SMAWeatherFetcherTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "SMAWeatherFetcher.h"

@interface SMAWeatherFetcherTests : XCTestCase

@property (nonatomic, strong) SMAWeatherFetcher *fetcher;

@end

@implementation SMAWeatherFetcherTests

- (void)setUp
{
    [super setUp];
    self.fetcher = OCMPartialMock([SMAWeatherFetcher new]);
}

- (void)tearDown
{
    self.fetcher = nil;
    [super tearDown];
}

- (void)testGetWeatherFromCoordinatesNil
{
    NSDictionary *coordinates = nil;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *weatherInfo = nil;
    [self.fetcher getWeatherFromCoordinates:coordinates completion:^(NSDictionary *weatherData) {
        isCalled = YES;
        weatherInfo = weatherData;
    }];
    expect(isCalled).after(5).beTruthy();
    expect(weatherInfo).after(5).beNil();
}

- (void)testGetWeatherFromCoordinatesReal
{
    NSDictionary *coordinates = @{
                                  @"lng": @"139.692",
                                  @"lat": @"35.6895"
                                  };
    NSSet *expectedKeys = [NSSet setWithArray:@[@"temperature", @"humidity", @"summary_weather"]];
    
    __block BOOL isCalled = NO;
    __block NSDictionary *weatherInfo = nil;
    [self.fetcher getWeatherFromCoordinates:coordinates completion:^(NSDictionary *weatherData) {
        isCalled = YES;
        weatherInfo = weatherData;
    }];
    expect(isCalled).after(5).beTruthy();
    expect(weatherInfo).after(5).notTo.beNil();
    expect([NSSet setWithArray:[weatherInfo allKeys]]).equal(expectedKeys);
}

- (void)testGetWeatherFromCoordinatesWrong
{
    NSDictionary *coordinates = @{
                                  @"wrong": @"139.692",
                                  };;
    
    __block BOOL isCalled = NO;
    __block NSDictionary *weatherInfo = nil;
    [self.fetcher getWeatherFromCoordinates:coordinates completion:^(NSDictionary *weatherData) {
        isCalled = YES;
        weatherInfo = weatherData;
    }];
    expect(isCalled).after(5).beTruthy();
    expect(weatherInfo).after(5).beNil();
}

@end
