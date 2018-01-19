//
//  SMAForecastServiceTests.m
//  WeatherTravelTests
//
//  Created by Maria Semakova on 1/19/18.
//  Copyright © 2018 Maria Semakova. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Expecta/Expecta.h>

#import "SMAForecastService.h"

@interface SMAForecastServiceTests : XCTestCase

@property (nonatomic, strong) SMAForecastService *service;

@end

@implementation SMAForecastServiceTests

- (void)setUp
{
    [super setUp];
    self.service = OCMPartialMock([SMAForecastService new]);
}

- (void)tearDown
{
    self.service = nil;
    [super tearDown];
}

- (void)testGetForecastForCityOnlineEmpty
{
    NSString *cityName = @"";
    
    __block BOOL isCalled = NO;
    [self.service getForecastForCityOnline:cityName completion:^(SMAForecastModel *model) {
        isCalled = YES;
    }];
    expect(isCalled).after(2).to.beFalsy();
}

- (void)testGetForecastForCityOnlineNoise
{
    NSString *cityName = @"dkjfjkdahfjdhfjkahfkahfdk";
    
    __block BOOL isCalled = NO;
    [self.service getForecastForCityOnline:cityName completion:^(SMAForecastModel *model) {
        isCalled = YES;
    }];
    expect(isCalled).after(2).to.beFalsy();
}

- (void)testGetForecastForCityOnlineReal
{
    NSString *cityName = @"London";
    
    __block BOOL isCalled = NO;
    __block SMAForecastModel *forecast = nil;
    [self.service getForecastForCityOnline:cityName completion:^(SMAForecastModel *model) {
        isCalled = YES;
        forecast = model;
    }];
    expect(isCalled).after(10).to.beTruthy();
    expect(forecast).after(10).toNot.beNil();
}

- (void)testGetForecastsHistory
{
    __block BOOL isCalled = NO;
    __block NSArray<SMAForecastModel *> *forecasts = nil;
    [self.service getForecastsHistoryCompletion:^(NSArray<SMAForecastModel *> *models) {
        isCalled = YES;
        forecasts = models;
    }];
    expect(isCalled).after(5).to.beTruthy();
    expect(forecasts).after(5).toNot.beNil();
}


@end
